From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Thu, 24 Feb 2011 10:03:07 -0600
Message-ID: <AANLkTi=gn+713wttLh+iZQqOQXAvkW2bEE7c=rGKurXs@mail.gmail.com>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com>
	<201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
	<1865303E0DED764181A9D882DEF65FB685DF762B45@shsmsx502.ccr.corp.intel.com>
	<201102020034.43808.johannes.hirte@fem.tu-ilmenau.de>
	<1865303E0DED764181A9D882DEF65FB68621CA7167@shsmsx502.ccr.corp.intel.com>
	<1298028713.11103.13.camel@mainframe>
	<1865303E0DED764181A9D882DEF65FB686421B24FB@shsmsx502.ccr.corp.intel.com>
	<1298559118.11224.40.camel@mainframe>
	<AANLkTimkEGAGjY17FX_EFGwo6RJEoEfQ3WdKhNUymSE+@mail.gmail.com>
	<1298563230-sup-9619@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-1?Q?Maria_Wikstr=F6m?= <maria@ponstudios.se>,
	"Zhong, Xin" <xin.zhong@intel.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298563230-sup-9619@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 24, 2011 at 10:00 AM, Chris Mason <chris.mason@oracle.com> =
wrote:
> Excerpts from Mitch Harder's message of 2011-02-24 10:55:15 -0500:
>> 2011/2/24 Maria Wikstr=F6m <maria@ponstudios.se>:
>> > m=E5n 2011-02-21 klockan 09:51 +0800 skrev Zhong, Xin:
>> >> The backtrace in your attachment looks like a known bug of 2.6.37=
 which have already been fixed in 2.6.38. I have no idea why latest btr=
fs still hang in your environment if there's no debug info...
>> >>
>> >
>> > Haha, yes that's very hard :)
>> >
>> > 2.6.38-rc6 and btrfs-unstable behaves the same way. I can close th=
e
>> > process with ctrl+c and it disappear a few seconds later. There is=
 no
>> > CPU usage. Reading works because I can start htop and watch "svn i=
nfo"
>> > disappear, but everything writing to btrfs slows down to a crawl. =
It
>> > takes about 1 minute to log in. So I had to put the logs on an oth=
er
>> > partition using ext3 to get the output from sysrq+t.
>> >
>>
>> I believe I've been experiencing this issue also. =A0However, my pro=
blem
>> usually results in a "No space left on device" error rather than a
>> lock-up or crash. =A0But I've bisected my issue to this patch, and m=
y
>> "btrfs fi show" and "btrfs fi df" looks similar to others who've
>> posted to this tread with all my space being allocated, but not used=
=2E
>>
>
> Sorry, which patch did you bisect the problem down to?
>

The patch at the head of this thread:

Btrfs: pwrite blocked when writing from the mmaped buffer of the same p=
age
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
