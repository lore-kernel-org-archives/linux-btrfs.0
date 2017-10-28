Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49451 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750781AbdJ1AMW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 20:12:22 -0400
Subject: Re: Data and metadata extent allocators [1/2]: Recap: The data story
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <6296fd2d-87a3-7f59-2b4b-48e3e40d3593@gmx.com>
Date: Sat, 28 Oct 2017 08:12:16 +0800
MIME-Version: 1.0
In-Reply-To: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r0wLhtWrfJCIGIp8cRkANXUlfV9tQ2a4V"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r0wLhtWrfJCIGIp8cRkANXUlfV9tQ2a4V
Content-Type: multipart/mixed; boundary="4832AtCp20sOm3MtEufV1wU1EXL2tqSUc";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6296fd2d-87a3-7f59-2b4b-48e3e40d3593@gmx.com>
Subject: Re: Data and metadata extent allocators [1/2]: Recap: The data story
References: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>
In-Reply-To: <14632e5d-74b9-e52f-6578-56139c42369c@mendix.com>

--4832AtCp20sOm3MtEufV1wU1EXL2tqSUc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B410=E6=9C=8828=E6=97=A5 02:17, Hans van Kranenburg wrote:
> Hi,
>=20
> This is a followup to my previous threads named "About free space
> fragmentation, metadata write amplification and (no)ssd" [0] and
> "Experiences with metadata balance/convert" [1], exploring how good or
> bad btrfs can handle filesystems that are larger than your average
> desktop computer and/or which see a pattern of writing and deleting hug=
e
> amounts of files of wildly varying sizes all the time.
>=20
> This message is a summary of the earlier posts. So, for whoever followe=
d
> the story, only boring old news here. In the next message as a reply on=

> this one, I'll add some thoughts about new adventures with metadata
> during the last weeks.
>=20
> My use case is using btrfs as filesystem for backup servers, which work=

> with collections of subvolumes/snapshots with related data, and add new=

> data and expire old snapshots daily.
>=20
> Until now, the following questions were already answered:
>=20
> Q: Why does the allocated but unused space for data keep growing all th=
e
> time?
> A: Because btrfs keeps allocating new raw space for data use, while
> there's more and more unused space inside already which isn't reused fo=
r
> new data.

In fact, btrfs data allocator can split its data allocation request, and
make them fit into smaller blocks.

For example, for highly fragmented data space (and of course, no
unallocated space for new chunk), btrfs will use small space in existing
chunks.

Just as fstests, generic/416.

But I think it should be done in a more aggressive manner to reduce
chunk allocation.

And balance under certain case can be very slow due to the amount of
snapshots/reflinks, so personally I don't really like the idea of
balance itself.

If it can be avoid by extent allocator, we should do it from the very
beginning.

Thanks,
Qu

>=20
> Q: How do I fight this and prevent getting into a situation where all
> raw space is allocated, risking a filesystem crash?
> A: Use btrfs balance to fight the symptoms. It reads data and writes it=

> out again without the free space fragments.
>=20
> Q: Why would it crash the file system when all raw space is allocated?
> Won't it start trying harder to reuse the free space inside?
> A: Yes, it will, for data. The big problem here is that allocation of a=

> new metadata chunk when needed is not possible any more.
>=20
> Q: Where does btrfs balance get the usage information from (what %
> filled a chunk / block group is)? How can I see this myself?
> A: It's a field of the "block group" item in metadata. The information
> can be read from the filesystem metadata using the tree search ioctl.
> Exploring this resulted in the first version of btrfs-heatmap. [2]
>=20
> Q: Ok, but I have many TiBs of data chunks which are ~75% filled and
> rewriting all that data is painful, takes a huge amount of time and eve=
n
> if I would do it full-time aside from doing backups and expiries, I
> won't succeed in fighting new fragmented free space that pops up. Help!=

> A: Yeah, we need something better.
>=20
> Q: How can I see what the pattern is of free space fragments in a block=

> group?
> A: For this, extent level pictures in btrfs-heatmap were added. [2]
>=20
> Q: Why do the pictures of my data block groups look like someone fired =
a
> shotgun at it. [3], [4]?
> A: Because the data extent allocator that is active when using the 'ssd=
'
> mount option both tends to ignore smaller free space fragments all the
> time, and also behaves in a way that causes more of them to appear. [5]=

>=20
> Q: Wait, why is there "ssd" in my mount options? Why does btrfs think m=
y
> iSCSI attached lun is an SSD?
> A: Because it makes wrong assumptions based on the rotational attribute=
,
> which we can also see in sysfs.
>=20
> Q: Why does this ssd mode ignore free space?
> A: Because it makes assumptions about the mapping of the addresses of
> the block device we see in linux and the storage in actual flash chips
> inside the ssd. Based on that information it decides where to write or
> where not to write any more.
>=20
> Q: Does this make sense in 2017?
> A: No. The interesting relevant optimization when writing to an ssd
> would be to write all data together that will be deleted or overwritten=

> together at the same time in the future. Since btrfs does not come with=

> a time machine included, it can't do this. So, remove this behaviour
> instead. [6]
>=20
> Q: What will happen when I use kernel 4.14 with the previously mentione=
d
> change, or if I change to the nossd mount option explicitely already?
> A: Relatively small free space fragments in existing chunks will
> actually be reused for new writes that fit, working from the beginning
> of the virtual address space upwards. It's like tetris, trying to
> completely fill up the lowest lines first. See the big difference in
> behavior when changing extent allocator happening at 16 seconds into
> this timelapse movie: [7] (virtual address space)
>=20
> Q: But what if all my chunks have badly fragmented free space right now=
?
> A: If your situation allows for it, the simplest way is running a full
> balance of the data, as some sort of big reset button. If you only want=

> to clean up chunks with excessive free space fragmentation, then you ca=
n
> use the helper I used to identify them, which is
> show_free_space_fragmentation.py in [8]. Just feed the chunks to balanc=
e
> starting with the one with the highest score. The script requires the
> free space tree to be used, which is a good idea anyway.
>=20
> [0] https://www.spinics.net/lists/linux-btrfs/msg64446.html
> [1] https://www.spinics.net/lists/linux-btrfs/msg64771.html
> [2] https://github.com/knorrie/btrfs-heatmap/
> [3]
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-10-27-shotgunblast.=
png
> [4]
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2016-12-18-heatmap-scrip=
ting/fsid_ed10a358-c846-4e76-a071-3821d423a99d_startat_320029589504_at_14=
82095269.png
> [5] https://www.spinics.net/lists/linux-btrfs/msg64418.html
> [6]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D583b723151794e2ff1691f1510b4e43710293875
> [7] https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-ssd-to-nossd.mp=
4
> [8] https://github.com/knorrie/python-btrfs/tree/develop/examples
>=20


--4832AtCp20sOm3MtEufV1wU1EXL2tqSUc--

--r0wLhtWrfJCIGIp8cRkANXUlfV9tQ2a4V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnzy2AXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiZKQf+N3H1ELyaah7eQU7Z92K8CUkr
ghB0DBoIh6KLq8+cisRcg+sjBzEG9zNUwsozrX4KV7SPApgvRa93MtPaT3pUReaQ
6lG8R1n3/KyU65NjjsZSNPOUunhRNWcn56ht8laWq3cv77130X46pEKDCCKDhkQp
vt7BKU6kvOHUDfh3IRFGzjlHr7i8NapJDo+/MUu6qI6Q03n6gyermUO/OeKMd2eI
jfXr2C/50u3QzK8Hhvp1unAkIz8PjNdH5biqstu7mUCtuQF8Y9bDlsibfoEBTaLC
Usd4WUQTN7hJV0hvBY3M+3vswrvnxwITUa/uI0KIvmp/x+IWGILQE+98Vs8TGQ==
=FHhR
-----END PGP SIGNATURE-----

--r0wLhtWrfJCIGIp8cRkANXUlfV9tQ2a4V--
