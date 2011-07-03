From: Skylar <BurtenshawsElectronics@Gmail.com>
Subject: Re: parent transid verify failures on 2.6.39
Date: Sun, 3 Jul 2011 07:09:27 +0000 (UTC)
Message-ID: <loom.20110701T000555-177@post.gmane.org>
References: <BANLkTikbunJJTxutLGfs0R_rSfbqWmBf=A@mail.gmail.com> <4DDD5852.3070501@redhat.com> <BANLkTin7rzxzp7LvoMGtnY+w3UYtHcpy0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Craig Johnson <crajohns <at> gmail.com> writes:

> 
> I can wait a couple of days for the new tool - glad to know that there
> is still hope.  If the new btrfsck isn't available within a week or so
> I might hit you up for that patch.  Thanks!
> 
> - Craig
> 
> On Wed, May 25, 2011 at 2:28 PM, Josef Bacik <josef <at> redhat.com> wrote:
> > On 05/25/2011 03:06 PM, Craig Johnson wrote:
> >> After doing an upgrade to 2.6.39 from 2.6.39-rc7, I am unable to mount
> >> my 3 disk btrfs volume.  It was a clean reboot, which makes it all the
> >> more puzzling.  This is what I'm getting:
> >>
> >>
> >> [68808.339109] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 2
> >> transid 339584 /dev/sdc1
> >> [68808.340354] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 1
> >> transid 339584 /dev/sda1
> >> [68808.340774] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 3
> >> transid 339584 /dev/sdb1
> >>
> >> [70106.913668] btrfs: disk space caching is enabled
> >> [70106.968648] parent transid verify failed on 6038227976192 wanted
> >> 337418 found 337853
> >> [70106.969031] parent transid verify failed on 6038227976192 wanted
> >> 337418 found 337853
> >> [70106.969403] parent transid verify failed on 6038227976192 wanted
> >> 337418 found 337853
> >> [70106.969671] parent transid verify failed on 6038227976192 wanted
> >> 337418 found 337853
> >> [70106.969691] parent transid verify failed on 6038227976192 wanted
> >> 337418 found 337853
> >> [70106.969704] Failed to read block groups: -5
> >> [70107.050658] btrfs: open_ctree failed
> >>
> >> I went to run a btrfsck, but found out that I needed to compile with
> >> the tmp branch or I would get an unsupported features message (lzo and
> >> space_cache).  After compiling that, when I run btrfsck, I get this:
> >>
> >> parent transid verify failed on 6038227976192 wanted 337418 found 337853
> >> parent transid verify failed on 6038227976192 wanted 337418 found 337853
> >> parent transid verify failed on 6038227976192 wanted 337418 found 337853
> >>
> >> And then it stops.  This happens with btrfs-debug-tree, or
> >> btrfs-select-super.  I've tried it on sda1, sdb1, and sdc1 and also
> >> with -s 0, -s 1, and -s 2.  Dmesg shows a segfault:
> >>
> >> [71775.589462] btrfsck[14453]: segfault at c4 ip 000000000040e477 sp
> >> 00007fffa9eb4d30 error 4 in btrfsck[400000+21000]
> >>
> >> For fun, I ran it through gdb and I got this:
> >>
> >> Program received signal SIGSEGV, Segmentation fault.
> >> find_first_block_group (root=0x61d1b0, path=0x61ef10, key=0x7fffffffe240)
> >>     at extent-tree.c:3028
> >> 3028                    if (slot >= btrfs_header_nritems(leaf)) {
> >>
> >>
> >>
> >> Is there any hope of recovery here?  Not the end of the world if the
> >> volume is lost, but it would be a bit of a pain and I'm at a loss as
> >> to why it happened.  I tried mounting with the new integration-test
> >> branch just for fun, but there's no difference on the mounting.  Any
> >> help that could be provided would be immensely appreciated.  Thanks!
> >>
> >
> > So I have a patch I can give you that will possibly help you recover
> > your data if you don't have backups, or you can wait a couple of days
> > (hopefully) for the new btrfsck tool that will be much better than the
> > hack I can give you.  Thanks,
> >
> > Josef
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Hate to be a pest, but is there any word on the release of this tool? I've been
silently and eagerly waiting, and figured I'd prod, in case I was looking in all
the wrong places. I'm faced with a 15tb (Yes, terabyte. 23 drives of varying
sizes.) array of random data that was lost to this problem. The rack UPS system
had failed batteries - SEVERELY neglected, sadly, not that it's of any relevance.

dmesg;
[236109.982618] device label SolaceNetArray devid 2 transid 267118 /dev/sds3
[236110.486189] btrfs: use zlib compression
[236110.624320] parent transid verify failed on 12377604001792 wanted 267118
found 47109
[236110.624480] parent transid verify failed on 12377604001792 wanted 267118
found 47109
[236110.624635] parent transid verify failed on 12377604001792 wanted 267118
found 47109
[236110.624640] parent transid verify failed on 12377604001792 wanted 267118
found 47109
[236110.670432] btrfs: open_ctree failed

The data is not mission-critical, but it does reperesent a very, very long
effort of collection and organization. Losing it would be a significant setback,
and I've been tasked with the process of recovery. Obviously at 15tb, an
off-site backup was not a cost-effective option. If there's anything I can do to
aid your efforts - though I honestly doubt it - please let me know.

I'm willing to try any "patch" or "hack" you're willing to provide, if it is
unlikely (obviously can't be guaranteed) to cause complete loss of the data.
Please let me know.

