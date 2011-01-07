From: cwillu <cwillu@cwillu.com>
Subject: Re: 'open_ctree failed', unable to mount the fs
Date: Fri, 7 Jan 2011 14:31:04 -0600
Message-ID: <AANLkTik27r9cgyGx9UU9=LVLHOCG0_O9YeHAtCuenQgw@mail.gmail.com>
References: <4D27631B.9020700@wpkg.org>
	<20110107190930.GA24059@carfax.org.uk>
	<84f68d319370863b2fed9181f93295b9.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Ken D'Ambrosio" <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <84f68d319370863b2fed9181f93295b9.squirrel@webmail.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 2:02 PM, Ken D'Ambrosio <ken@jots.org> wrote:
> On Fri, January 7, 2011 2:09 pm, Hugo Mills wrote:
>> On Fri, Jan 07, 2011 at 08:01:47PM +0100, Tomasz Chmielewski wrote:
>>
>>> I got a "power cycle", after which I'm no longer able to mount btrf=
s
>>> filesystem:
> [...]
>> The forthcoming[1] btrfsck tool should handle that particular
>> error, I believe.
>
> I tried it with the btrfsck in the git repo (last week), and wound up
> with... a brandy-new, blank btrfs partition. =A0Not *quite* what I wa=
s
> looking for. =A0But at least it mounted.

btrfsck in git hasn't been updated since October; the upcoming fsck
work isn't public, presumably to avoid making things worse until it's
working right.  The current btrfsck doesn't write to the partition as
far as I'm aware.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
