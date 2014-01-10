Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob09.myregisteredsite.com ([209.17.115.47]:57745 "EHLO
	atl4mhob09.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbaAJPqE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jan 2014 10:46:04 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob09.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s0AFk298004583
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jan 2014 10:46:02 -0500
Message-ID: <52D015D5.4050909@chinilu.com>
Date: Fri, 10 Jan 2014 07:46:29 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: How does btrfs handle bad blocks in raid1?
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>	<20140109104247.GH15634@carfax.org.uk>	<pan$ab233$2067aff9$a13049e6$e769dc55@cox.net>	<52CE9B9C.2040006@gmail.com>	<pan$5a8b0$23680cbf$a1bd97e9$1743c66f@cox.net>	<CAPpBBdNNHB3igMK67j5FpZxg7f6tmxGZk8x1OSwKd8GhTqsj=w@mail.gmail.com> <pan$d99db$e3c147a3$da4732f1$5ec5ee5@cox.net>
In-Reply-To: <pan$d99db$e3c147a3$da4732f1$5ec5ee5@cox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/10/2014 07:27 AM, Duncan wrote:
> George Eleftheriou posted on Thu, 09 Jan 2014 17:49:48 +0100 as excerpted:
>
>> I'm really looking forward to the day that typing:
>>
>> mkfs.btrfs -d raid10 -m raid10  /dev/sd[abcd]
>>
>> will do exactly what is expected to do. A true RAID10 resilient in 2
>> disks' failure. Simple and beautiful.
>>
>> We're almost there...
> I see the further discussion, but three comments:
>
> 1) (As should be obvious by now, but as the saying goes...)
>
> I want N-way-mirroring so bad I can taste it!  =:^)
>
> 2) Assuming a guaranteed 2-device-drop safe 3(+)-way-mirroring
> possibility, the above mkfs.btrfs would by the same assumption of
> necessity be a bit more complicated than that (and would require six
> devices of the same size for simplest conceptual formulation, not the
> four shown above).
>
> Because at that point, a distinction between these two possibilities for
> a 6-device raid10 would need to be made:
>
> * Two-way raid1/mirror on the devices, three-way raid0/stripe on top.
>
> This is the current default and only choice, as discussed elsewhere in
> the subthread.  The three-way-stripe is 3X fast (ideal, probably more
> like 2X fast in practice, allowing for overhead), while the 2-way-mirror
> provides guaranteed 1-device-drop safety, with a possibility to lose two
> devices and recover, or not, depending on which two they are.
>
> For maximum backward compatibility with what we have now, since it /is/
> what we have now, that's likely what you'd still get with this:
>
> mkfs.btrfs -d raid10 -m raid10 /dev/sd[abcdef]
>
> ... but it'd only guarantee single-device-drop safety.
>
> The alternative, which I want so bad I can taste it, would be:
>
> * Three-way raid1/mirror on the devices, two-way raid0/stripe on top.
>
> That would sacrifice the 3X speed reducing it to 2X (ideal, probably 1.5X
> in practice due to overhead), but the 3-way-mirror would provide *BOTH*
> guaranteed 2-device-drop safety, *AND* guaranteed checksummed 3-way
> individual-btrfs-node integrity-checked mirroring, such that should any
> two of the three mirrors fail checksum, there'd still be that third copy.
>
> What would the mkfs.btrfs command look like for that?  I've no insight on
> exactly how they plan to implement it, but here's one possible idea:
>
> mkfs.btrfs -d raid10.3 -m raid10.3 /dev/sd[abcdef]
>
> The ".3" bit would indicate three-way-mirroring instead of the default 2-
> way-mirroring.  It has the advantage of relative brevity, but isn't
> entirely intuitive.
>
> Another possibility would be a more explicit two-component mode-spec,
> like this:
>
> mkfs.btrfs -d mirror3 (-d) raid10, -m mirror3 (-m) raid10 /dev/sd[abcdef]
>
> (Whether the second -d/-m specifier was required to be there, optional,
> or could not be there, would depend on how they setup the parser.
> Another option would be a no-space comma separator: -d mirror3,raid10
> -m mirror3,raid10 .)
>
> This is more verbose but MUCH clearer, and as such I believe would be
> preferred to the dot-format, since after all, mkfs isn't something most
> peope do a lot of, so clarity should be preferred to brevity.  And I'd
> predict the no-space-comma-separator, since that format's least
> complicated in terms of shell parsing, and is already familiar from usage
> in fstab, among other places.
>
> Oh, that would taste SOOO good! =:^)
>
> 3) Just for clarity in case anyone were to get mixed up, those devices
> can be partitions (or for that matter, mdraids or whatever) too.  They
> don't have to be actual whole physical devices.  So /dev/sd[abcdef]5 ,
> for instance, would work too.  That's actually what I'm already doing
> here, altho obviously not with the n-way-mirroring I so want, as it's not
> available yet.
>
> (This comment specifically included since the fact that multi-device
> btrfs could be on partition-devices wasn't clear to at least one list
> poster, not that long ago.  So just to make it explicitly clear to
> anybody stumbling on this post from google or whatever...)
>
Duncan, you are describing exactly the sort of ROBUST RAID product I 
would like to see btrfs become.  In this world of ridiculously 
inexpensive hard drives I don't think we should ever have to risk ending 
up in a degraded state, at least certainly not for long, but not ever 
would be ideal.  We should never end up being in a panic to change out a 
drive and facing additional panic as to whether a rebuild is going to 
succeed or fall on its face.  Those days should be over forever, 
barring, of course, a direct nuclear hit.  - George
