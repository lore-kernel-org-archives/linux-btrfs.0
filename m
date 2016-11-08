Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:49646
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753006AbcKHQ65 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Nov 2016 11:58:57 -0500
Subject: Re: Announcing btrfs-dedupe
To: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <e9a425e6-0f1a-42ca-8200-1cad1193f048@linuxsystems.it>
 <7c1d65d8-3a95-1a1b-761f-8d765ed4e3e3@wellbehavedsoftware.com>
 <15418748-e831-4056-b399-39e4f50369de@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org
From: James Pharaoh <james@wellbehavedsoftware.com>
Message-ID: <23ae5e65-f6f1-3167-abeb-65b99aeca7cd@wellbehavedsoftware.com>
Date: Tue, 8 Nov 2016 17:58:52 +0100
MIME-Version: 1.0
In-Reply-To: <15418748-e831-4056-b399-39e4f50369de@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, everything you have described here is something I intend to create, 
and might as well include in the tool itself. I'll add it to the roadmap ;-)

James

On 08/11/16 17:57, Niccolò Belli wrote:
> On martedì 8 novembre 2016 12:38:48 CET, James Pharaoh wrote:
>> You can't deduplicate a read-only snapshot, but you can create
>> read-write snapshots from them, deduplicate those, and then recreate
>> the read-only ones. This is what I've done.
>
> Since snapper creates hundreds of snapshots, isn't this something that
> the deduplication software could do for me if I explicitely tell it to
> do so? I mean momentarily switching the snapshot to rw in order to
> deduplicate it, then switching it back to ro.
>
>> In theory, once this has been done once, it shouldn't have to be done
>> again, at least for those snapshots, unless you want to modify the
>> deduplication. It's probably a good idea to defragment files and
>> directories first, as well.
>
> I can't defragment anything, because it would take too much free space
> to do so with so many snapshots. Instead, the deduplication software
> could defragment each file before calling the extent-same ioctl, that
> would be feasible. Such a way you will not need hilarious amounts of
> free space to defragment the fs.
>
>> It should be possible to deduplicate a read-only file to a read-write
>> one, but that's probably not worth the effort in many real-world use
>> cases.
>
> This is exactly what I would expect a deduplication tool to do when it
> encounters a ro snapshot, except when I explicitely tell it to
> momentarily switch the snapshot to rw in order to deduplicate it.
>
> Niccolo' Belli
