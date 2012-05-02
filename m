From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs across a mix of SSDs & HDDs
Date: Wed, 2 May 2012 12:30:36 +0700
Message-ID: <CAG1y0scNSit6oCvySUiP6RChx3_LLDY1QBML0BpGM-39etnZLQ@mail.gmail.com>
References: <jnpdud$ta9$1@dough.gmane.org>
	<jnq5os$tdn$1@dough.gmane.org>
	<CAG1y0sfMJ4TtOE3C6hTBH59ESZcomDs0uHJEpowC-8e=6s86cQ@mail.gmail.com>
	<jnqf0j$hcd$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Bardur Arantsson <spam@scientician.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jnqf0j$hcd$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 2, 2012 at 12:00 PM, Bardur Arantsson <spam@scientician.net=
> wrote:
> On 05/02/2012 06:28 AM, Fajar A. Nugraha wrote:

>>> =A0From Kconfig:
>>>
>>> =A0 "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^ =A0 ^^^^^^^=
^^^^^^^^^^^
>>>
>>> Btrfs is too immature to use in ANY kind of production-like scenari=
o
>>> where
>>> you cannot afford to lose a certain amount of data (i.e. be forced =
to
>>> restore from backup) AND suffer downtime.
>>>
>>> I don't think email users are going to be thrilled about the prospe=
ct of
>>> "lossy" email.
>>
>>
>> Oracle fully supports btrfs for production environment:
>> http://oss.oracle.com/ol6/docs/RELEASE-NOTES-UEK2-en.html
>>
>> http://www.zdnet.com/blog/open-source/oracles-unbreakable-enterprise=
-kernel-2-arrives-with-linux-30-kernel-btrfs/10588
>> http://www.oracle.com/us/technologies/linux/index.html
>>
>
> What does "fully supports" mean? Does it mean that it's actually stab=
le
> (considerably more stable that mainline), or does it mean that you ca=
n pay
> them to help fix a broken FS, for example? Does the included btrfsck
> actually work reliably? Is there some non-legalese official statement=
 of
> what, exactly, "fully supported" means and whether OL's btrfs falls u=
nder
> this rubric?

That question would be best addressed to Oracle directly. Or other
distro vendors supporting btrfs (IIRC SLES also supports it).

>
> Also, AFAIUI the 3.0.x kernels (which OL claims to use in the release=
 notes)
> are woefully outdated wrt. btrfs reliability/stability. Have all the =
more
> recent stability improvements been backported?

Chris or other devs from oracle might be able to comment more on that.

I know that it's quite common for an OSS vendor to have a supported
version of something, based on a version that is more thoroughly
tested, and have another version (in this case the version of btrfs in
mainline) that has newer, bleeding-edge code, with more features, but
possibly also more bugs.

>
> Is the OP using Oracle Linux?

He didn't say. But he didn't say he WON'T be using oracle linux (or
other distro which supports btrfs) either. Plus the kernel can be
installed on top of RHEL/Centos 5 and 6, so he can easily choose
either the supported version, or the mainline version, each with its
own consequences.

> Given the semi-regular posts about FS corruption on this list(*) and =
the
> "EXPERIEMENTAL" status in the KConfig it would be unwise to use btrfs=
 for
> anything called "production" (unless you can actually afford downtime=
/data
> loss).

=46air opinion.

Personally I'm quite happy with the version that is included in Ubuntu
Precise (kernel 3.2). It has actually helped me recover from a bad
SSD. It was a somewhat old SSD, and about 1GB (out of 50GB) data
becomes unreadable (reading directly from the block device). "btrfs
scrub" was helpful enough to help me find out which files are
corrupted, something I wouldn't be able to do with ext4.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
