From: Michael Stephenson <mickstephenson@googlemail.com>
Subject: Re: Filesystem corrupted, is there any hope?
Date: Fri, 24 Jun 2011 16:39:12 +0100
Message-ID: <BANLkTikPsdxJ2Z=hit63KjG=8wvKp_MJHw@mail.gmail.com>
References: <BANLkTikLCk9=_CgXUWUTf91x7Aiyhuvndg@mail.gmail.com>
	<BANLkTi=1Jpc9E-XW8jY6uVYhukMTL2W_vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Fajar A. Nugraha" <list@fajar.net>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=1Jpc9E-XW8jY6uVYhukMTL2W_vQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 24 June 2011 14:46, Fajar A. Nugraha <list@fajar.net> wrote:
> On Fri, Jun 24, 2011 at 5:16 PM, Michael Stephenson
> <mickstephenson@googlemail.com> wrote:
>> Hello,
>> I formatted my home partition with btrfs, not realising that the fsck
>> tool can't actually fix errors, as I have just discovered on your
>> wiki.
>> Had I knew this I would have not used it so early, this detail you
>> would think would make distributions wary to make it an option on the
>> livecd with no warning that if you ever have a power cut you are most
>> certainly going to lose your data even if your hardware is fine.
>> Anyway is their any hope? Is there beta code for an fsck that can do
>> repairs? How long do I have to wait before there is? I can always just
>> wait for a few months to get the data back.
>
> That depends on what kind of corruption you have (dmesg / syslog
> output would be nice)
>
> For some cases, you can try:
> - "btrfsck -s1", and if can finish without errors, try  btrfs-select-super
> - if it complains about some transid not available, try btrfs-zero-log
>
> both btrfs-select-super and btrfs-zero-log need to be compiled
> manually from source (i.e. "make btrfs-select-super" and "make
> btrfs-zero-log"). if you use lzo, you might need the tmp branch
> (http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=shortlog;h=refs/heads/tmp)
>
> Some more suggestions:
> - when possible, create a copy first of the device (e.g. with
> dd_rescue) and work on the copy
> - use "mount -o ro", and if readonly mount is successful, copy the
> files somewhere safe and recreate your fs.
>
> --
> Fajar
>

Thanks Fajar, unfortunately no luck

Dmesg:

[ 2189.479480] device fsid 6e2d8107-ab82-4e4e-8192-35838be4c944 devid
1 transid 329656 /dev/sda1
[ 2189.502076] parent transid verify failed on 87023616 wanted 326896
found 328741
[ 2189.502418] parent transid verify failed on 87023616 wanted 326896
found 328741
[ 2189.502765] parent transid verify failed on 87023616 wanted 326896
found 328741
[ 2189.502782] parent transid verify failed on 87023616 wanted 326896
found 328741
[ 2189.540344] btrfs: open_ctree failed

 btrfsck -s1 /dev/sda1
parent transid verify failed on 87023616 wanted 326896 found 328741
parent transid verify failed on 87023616 wanted 326896 found 328741
parent transid verify failed on 87023616 wanted 326896 found 328741
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)' failed.
Aborted

./btrfs-zero-log /dev/sda1
parent transid verify failed on 87023616 wanted 326896 found 328741
parent transid verify failed on 87023616 wanted 326896 found 328741
parent transid verify failed on 87023616 wanted 326896 found 328741
btrfs-zero-log: disk-io.c:416: find_and_setup_root: Assertion
`!(!root->node)' failed.
Aborted

Does this mean I'm screwed?

Regards Michael.
