From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs across a mix of SSDs & HDDs
Date: Wed, 2 May 2012 11:28:53 +0700
Message-ID: <CAG1y0sfMJ4TtOE3C6hTBH59ESZcomDs0uHJEpowC-8e=6s86cQ@mail.gmail.com>
References: <jnpdud$ta9$1@dough.gmane.org>
	<jnq5os$tdn$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jnq5os$tdn$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 2, 2012 at 9:22 AM, Bardur Arantsson <spam@scientician.net>=
 wrote:
> On 05/01/2012 09:35 PM, Martin wrote:
>>
>> How well does btrfs perform across a mix of:
>>
>> 1 SSD and 1 HDD for 'raid' 1 mirror for both data and metadata?

>> The idea is to gain the random access speed of the SSDs but have the
>> HDDs as backup in case the SSDs fail due to wear...

AFAIK only zfs officially supports that configuration, using L2ARC and =
SLOG

>>
>> The usage is to support a few hundred Maildirs + imap for users that
>> often have many thousands of emails in the one folder for their inbo=
x...

Some mail programs uses hardlinks, and btrfs has a low limit on
maximum number of hardlinks in a directory. If you use one of those
programs, better stay away for now.

Plus, from my experience, when using the same disk, btrfs will use up
more disk I/O compared to ext4, so if you're already I/O-starved,
better stick with ext4.


>> Or is btrfs yet too premature to suffer such use?
>>
>
> From Kconfig:
>
> =A0 "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^ =A0 ^^^^^^^^^=
^^^^^^^^^
>
> Btrfs is too immature to use in ANY kind of production-like scenario =
where
> you cannot afford to lose a certain amount of data (i.e. be forced to
> restore from backup) AND suffer downtime.
>
> I don't think email users are going to be thrilled about the prospect=
 of
> "lossy" email.

Oracle fully supports btrfs for production environment:
http://oss.oracle.com/ol6/docs/RELEASE-NOTES-UEK2-en.html
http://www.zdnet.com/blog/open-source/oracles-unbreakable-enterprise-ke=
rnel-2-arrives-with-linux-30-kernel-btrfs/10588
http://www.oracle.com/us/technologies/linux/index.html

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
