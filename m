Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:36826 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbbH2IxA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Aug 2015 04:53:00 -0400
Received: by labnh1 with SMTP id nh1so20451061lab.3
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Aug 2015 01:52:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150828093502.GO23769@carfax.org.uk>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
	<20150826165024.05af044f@natsu>
	<55DDAB1C.90406@gmail.com>
	<CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
	<20150828093502.GO23769@carfax.org.uk>
Date: Sat, 29 Aug 2015 10:52:59 +0200
Message-ID: <CAG__1a7WWVORLm3JZKwg8BgvA=+LM+i4Dwxjs72sBpHP1XM4uw@mail.gmail.com>
Subject: Re: Understanding BTRFS storage
From: George Duffield <forumscollective@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        George Duffield <forumscollective@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Funny you should say that, whilst I'd read about it it didn't concern
me much until Neil Brown himself advised me against expanding the
raid5 arrays any further (one was built using 3TB drives and the other
using 4TB drives).  My understanding is that larger arrays are
typically built using more drives of lower capacity.  I'm also loathe
to use mdadm as expanding arrays takes forever whereas a Btrfs array
should expand much quicker.  If Btrfs raid isn't yet ready for prime
time I'll just hold off doing anything for the moment, frustrating as
that is.

On Fri, Aug 28, 2015 at 11:35 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Aug 28, 2015 at 10:50:12AM +0200, George Duffield wrote:
>> Running a traditional raid5 array of that size is statistically
>> guaranteed to fail in the event of a rebuild.
>
>    Except that if it were, you wouldn't see anyone running RAID-5
> arrays of that size and (considerably) larger. And successfully
> replacing devices in them.
>
>    As I understand it, the calculations that lead to the conclusion
> you quote are based on the assumption that the bit error rate (BER) of
> the drive is applied on all reads -- this is not the case. The BER is
> the error rate of the platter after the device has been left unread
> (and powered off) for some long period of time. (I've seen 5 years
> been quoted for that).
>
>    Hugo.
>
>> I also need to expand
>> the size of available storage to accomodate future storage
>> requirements. My understanding is that a Btrfs array is easily
>> expanded without the overhead associated with expanding a traditional
>> array.  Add to that the ability to throw varying drive sizes at the
>> problem and a Btrfs RAID array looks pretty appealing.
>>
>> For clarity, my intention is to create a Btrfs array using new drives,
>> not to convert the existing ext4 raid5 array.
>>
>> On Wed, Aug 26, 2015 at 2:03 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>> > On 2015-08-26 07:50, Roman Mamedov wrote:
>> >>
>> >> On Wed, 26 Aug 2015 10:56:03 +0200
>> >> George Duffield <forumscollective@gmail.com> wrote:
>> >>
>> >>> I'm looking to switch from a 5x3TB mdadm raid5 array to a Btrfs based
>> >>> solution that will involve duplicating a data store on a second
>> >>> machine for backup purposes (the machine is only powered up for
>> >>> backups).
>> >>
>> >>
>> >> What do you want to achieve by switching? As Btrfs RAID5/6 is not safe
>> >> yet, do
>> >> you also plan to migrate to RAID10, losing in storage efficiency?
>> >>
>> >> Why not use Btrfs in single-device mode on top of your mdadm RAID5/6? Can
>> >> even
>> >> migrate without moving any data if you currently use Ext4, as it can be
>> >> converted to Btrfs in-place.
>> >>
>> > As of right now, btrfs-convert does not work reliably or safely.  I would
>> > strongly advise against using it unless you are trying to help get it
>> > working again.
>> >
>
> --
> Hugo Mills             | Beware geeks bearing GIFs
> hugo@... carfax.org.uk |
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |
