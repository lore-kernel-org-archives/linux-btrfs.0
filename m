Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:42352 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1750916AbcKYEbV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 23:31:21 -0500
Date: Thu, 24 Nov 2016 23:31:19 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
Message-ID: <20161125043119.GG8685@hungrycats.org>
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="K1n7F7fSdjvFAEnM"
In-Reply-To: <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--K1n7F7fSdjvFAEnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 22, 2016 at 07:02:13PM +0100, Goffredo Baroncelli wrote:
> On 2016-11-22 01:28, Qu Wenruo wrote:
> >=20
> >=20
> > At 11/22/2016 02:48 AM, Goffredo Baroncelli wrote:
> >> Hi Qu,
> >>
> >> I tested this succefully for RAID5 when doing a scrub (i.e.: I mount a=
 corrupted disks, then I ran "btrfs scrub start ...", then I check the disk=
s).
> >>
> >> However if I do a "cat mnt/out.txt" (out.txt is the corrupted file):
> >> 1) the system detect that the file is corrupted   (good :) )
> >> 2) the system return the correct file content     (good :) )
> >> 3) the data on the platter are still wrong        (no good :( )
> >=20
> > Do you mean, read the corrupted data won't repair it?
> >=20
> > IIRC that's the designed behavior.
>=20
> :O
>=20
> You are right... I was unaware of that....

This is correct.

Ordinary reads shouldn't touch corrupt data, they should only read
around it.  Scrubs in read-write mode should write corrected data over
the corrupt data.  Read-only scrubs can only report errors without
correcting them.

Rewriting corrupt data outside of scrub (i.e. on every read) is a
bad idea.  Consider what happens if a RAM controller gets too hot:
checksums start failing randomly, but the data on disk is still OK.
If we tried to fix the bad data on every read, we'd probably just trash
the filesystem in some cases.

This risk mitigation measure does rely on admins taking a machine in this
state down immediately, and also somehow knowing not to start a scrub
while their RAM is failing...which is kind of an annoying requirement
for the admin.

> So you can add a "tested-by: Goffredo Baroncelli <kreijack@inwind.it>"
>=20
> BR
> G.Baroncelli
>=20
> >=20
> > For RAID5/6 read, there are several different mode, like READ_REBUILD o=
r SCRUB_PARITY.
> >=20
> > I'm not sure for write, but for read it won't write correct data.
> >=20
> > So it's a designed behavior if I don't miss something.
> >=20
> > Thanks,
> > Qu
> >=20
> >>
> >>
> >> Enclosed the script which reproduces the problem. Note that:
> >> If I corrupt the data, in the dmesg two time appears a line which says:
> >>
> >> [ 3963.763384] BTRFS warning (device loop2): csum failed ino 257 off 0=
 csum 2280586218 expected csum 3192393815
> >> [ 3963.766927] BTRFS warning (device loop2): csum failed ino 257 off 0=
 csum 2280586218 expected csum 3192393815
> >>
> >> If I corrupt the parity, of course the system doesn't detect the corru=
ption nor try to correct it. But this is the expected behavior.
> >>
> >> BR
> >> G.Baroncelli
> >>
> >>
> >>
> >> On 2016-11-21 09:50, Qu Wenruo wrote:
> >>> In the following situation, scrub will calculate wrong parity to
> >>> overwrite correct one:
> >>>
> >>> RAID5 full stripe:
> >>>
> >>> Before
> >>> |     Dev 1      |     Dev  2     |     Dev 3     |
> >>> | Data stripe 1  | Data stripe 2  | Parity Stripe |
> >>> --------------------------------------------------- 0
> >>> | 0x0000 (Bad)   |     0xcdcd     |     0x0000    |
> >>> --------------------------------------------------- 4K
> >>> |     0xcdcd     |     0xcdcd     |     0x0000    |
> >>> ...
> >>> |     0xcdcd     |     0xcdcd     |     0x0000    |
> >>> --------------------------------------------------- 64K
> >>>
> >>> After scrubbing dev3 only:
> >>>
> >>> |     Dev 1      |     Dev  2     |     Dev 3     |
> >>> | Data stripe 1  | Data stripe 2  | Parity Stripe |
> >>> --------------------------------------------------- 0
> >>> | 0xcdcd (Good)  |     0xcdcd     | 0xcdcd (Bad)  |
> >>> --------------------------------------------------- 4K
> >>> |     0xcdcd     |     0xcdcd     |     0x0000    |
> >>> ...
> >>> |     0xcdcd     |     0xcdcd     |     0x0000    |
> >>> --------------------------------------------------- 64K
> >>>
> >>> The calltrace of such corruption is as following:
> >>>
> >>> scrub_bio_end_io_worker() get called for each extent read out
> >>> |- scriub_block_complete()
> >>>    |- Data extent csum mismatch
> >>>    |- scrub_handle_errored_block
> >>>       |- scrub_recheck_block()
> >>>          |- scrub_submit_raid56_bio_wait()
> >>>             |- raid56_parity_recover()
> >>>
> >>> Now we have a rbio with correct data stripe 1 recovered.
> >>> Let's call it "good_rbio".
> >>>
> >>> scrub_parity_check_and_repair()
> >>> |- raid56_parity_submit_scrub_rbio()
> >>>    |- lock_stripe_add()
> >>>    |  |- steal_rbio()
> >>>    |     |- Recovered data are steal from "good_rbio", stored into
> >>>    |        rbio->stripe_pages[]
> >>>    |        Now rbio->bio_pages[] are bad data read from disk.
> >>>    |- async_scrub_parity()
> >>>       |- scrub_parity_work() (delayed_call to scrub_parity_work)
> >>>
> >>> scrub_parity_work()
> >>> |- raid56_parity_scrub_stripe()
> >>>    |- validate_rbio_for_parity_scrub()
> >>>       |- finish_parity_scrub()
> >>>          |- Recalculate parity using *BAD* pages in rbio->bio_pages[]
> >>>             So good parity is overwritten with *BAD* one
> >>>
> >>> The fix is to introduce 2 new members, bad_ondisk_a/b, to struct
> >>> btrfs_raid_bio, to info scrub code to use correct data pages to
> >>> re-calculate parity.
> >>>
> >>> Reported-by: Goffredo Baroncelli <kreijack@inwind.it>
> >>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> >>> ---
> >>> Thanks to the above hell of delayed function all and damn stupid code
> >>> logical, such bug is quite hard to trace.
> >>>
> >>> The damn kernel scrub is already multi-thread, why do such meaningless
> >>> delayed function call again and again?
> >>>
> >>> What's wrong with single thread scrub?
> >>> We can do thing like in each stripe for raid56 which is easy and
> >>> straightforward, only delayed thing is to wake up waiter:
> >>>
> >>>     lock_full_stripe()
> >>>     if (!is_parity_stripe()) {
> >>>         prepare_data_stripe_bios()
> >>>         submit_and_wait_bios()
> >>>         if (check_csum() =3D=3D 0)
> >>>             goto out;
> >>>     }
> >>>     prepare_full_stripe_bios()
> >>>     submit_and_wait_bios()
> >>>
> >>>     recover_raid56_stipres();
> >>>     prepare_full_stripe_write_bios()
> >>>     submit_and_wait_bios()
> >>>
> >>> out:
> >>>       unlock_full_stripe()
> >>>
> >>> We really need to re-work the whole damn scrub code.
> >>>
> >>> Also, we need to enhance btrfs-progs to detect scrub problem(my
> >>> submitted offline scrub is good enough for such usage), and tools to
> >>> corrupt extents reliably to put it into xfstests test cases.
> >>>
> >>> RAID56 scrub code is neither tested nor well-designed.
> >>> ---
> >>>  fs/btrfs/raid56.c | 29 ++++++++++++++++++++++++++++-
> >>>  1 file changed, 28 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> >>> index d016d4a..87e3565 100644
> >>> --- a/fs/btrfs/raid56.c
> >>> +++ b/fs/btrfs/raid56.c
> >>> @@ -133,6 +133,16 @@ struct btrfs_raid_bio {
> >>>      /* second bad stripe (for raid6 use) */
> >>>      int failb;
> >>>
> >>> +    /*
> >>> +     * For steal_rbio, we can steal recovered correct page,
> >>> +     * but in finish_parity_scrub(), we still use bad on-disk
> >>> +     * page to calculate parity.
> >>> +     * Use these members to info finish_parity_scrub() to use
> >>> +     * correct pages
> >>> +     */
> >>> +    int bad_ondisk_a;
> >>> +    int bad_ondisk_b;
> >>> +
> >>>      int scrubp;
> >>>      /*
> >>>       * number of pages needed to represent the full
> >>> @@ -310,6 +320,12 @@ static void steal_rbio(struct btrfs_raid_bio *sr=
c, struct btrfs_raid_bio *dest)
> >>>      if (!test_bit(RBIO_CACHE_READY_BIT, &src->flags))
> >>>          return;
> >>>
> >>> +    /* Record recovered stripe number */
> >>> +    if (src->faila !=3D -1)
> >>> +        dest->bad_ondisk_a =3D src->faila;
> >>> +    if (src->failb !=3D -1)
> >>> +        dest->bad_ondisk_b =3D src->failb;
> >>> +
> >>>      for (i =3D 0; i < dest->nr_pages; i++) {
> >>>          s =3D src->stripe_pages[i];
> >>>          if (!s || !PageUptodate(s)) {
> >>> @@ -998,6 +1014,8 @@ static struct btrfs_raid_bio *alloc_rbio(struct =
btrfs_root *root,
> >>>      rbio->stripe_npages =3D stripe_npages;
> >>>      rbio->faila =3D -1;
> >>>      rbio->failb =3D -1;
> >>> +    rbio->bad_ondisk_a =3D -1;
> >>> +    rbio->bad_ondisk_b =3D -1;
> >>>      atomic_set(&rbio->refs, 1);
> >>>      atomic_set(&rbio->error, 0);
> >>>      atomic_set(&rbio->stripes_pending, 0);
> >>> @@ -2352,7 +2370,16 @@ static noinline void finish_parity_scrub(struc=
t btrfs_raid_bio *rbio,
> >>>          void *parity;
> >>>          /* first collect one page from each data stripe */
> >>>          for (stripe =3D 0; stripe < nr_data; stripe++) {
> >>> -            p =3D page_in_rbio(rbio, stripe, pagenr, 0);
> >>> +
> >>> +            /*
> >>> +             * Use stolen recovered page other than bad
> >>> +             * on disk pages
> >>> +             */
> >>> +            if (stripe =3D=3D rbio->bad_ondisk_a ||
> >>> +                stripe =3D=3D rbio->bad_ondisk_b)
> >>> +                p =3D rbio_stripe_page(rbio, stripe, pagenr);
> >>> +            else
> >>> +                p =3D page_in_rbio(rbio, stripe, pagenr, 0);
> >>>              pointers[stripe] =3D kmap(p);
> >>>          }
> >>>
> >>>
> >>
> >>
> >=20
> >=20
> >=20
>=20
>=20
> --=20
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
>=20

--K1n7F7fSdjvFAEnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlg3vpcACgkQgfmLGlazG5ym2ACXSgutPkSSlJRpxkDoQCNx9x3R
jgCfcNhdQHLHrjTqkIYMbIDo/Z4PVPI=
=oe+m
-----END PGP SIGNATURE-----

--K1n7F7fSdjvFAEnM--
