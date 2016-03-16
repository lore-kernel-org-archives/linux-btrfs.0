Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38654 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTzA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 15:55:00 -0400
Received: by mail-wm0-f44.google.com with SMTP id l68so88018923wml.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Mar 2016 12:54:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160316140109.3497dfa6@natsu>
References: <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
 <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
 <CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
 <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
 <20160211191741.GA4762@localhost.localdomain> <CABXGCsPN3MOLkU68gpw=TsnZLODEkYZ66ZHgUxMyeqbdNME9Sw@mail.gmail.com>
 <20160212032226.GA10542@localhost.localdomain> <CABXGCsNjHq4M8TBibeWQLyK+Of0cu++P3QQ=+e=TUuZjaPMLtA@mail.gmail.com>
 <20160212203426.GA24399@localhost.localdomain> <CABXGCsMMkcMmEH8=d3TqJksB8uc_OVrRqfjX7E1RO+4R94O=Ug@mail.gmail.com>
 <20160214213224.GB28882@localhost.localdomain> <20160215034219.2f0df0ce@natsu>
 <CABXGCsOVeEBn9A=Wj6VtAEsban6LKj6B958gN8JqK9omLjDt9A@mail.gmail.com> <20160316140109.3497dfa6@natsu>
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Thu, 17 Mar 2016 00:54:44 +0500
Message-ID: <CABXGCsOuopUNy6p3S69Fsbu6OROx9pgo7S5w3R-o11RoL4vJMg@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
To: Roman Mamedov <rm@romanrm.net>
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-03-16 14:01 GMT+05:00 Roman Mamedov <rm@romanrm.net>:
> On Tue, 15 Mar 2016 09:18:14 +0500
> Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com> wrote:
>
>> Yesterday btrfs again hangs on kernel 4.4.5
>> It's the same or another problem?
>
> Seems different to me, as there's also defrag involved. Try removing and not
> using the defrag mount option.

How then defragment FS?

>
>> This messages say that restore failed?
>
> So you can't mount the FS anymore? Did you try btrfsck, what does it report?
>

FS is mounted, but after failure mount takes a long time (more than 4
min) and Fedora  stops boot  by timeout (system suggest enter under
root for maintance) after reboot again all fine.

I'm just afraid of losing data after this messages:
[  449.949206] BTRFS warning (device sdc1): failed to load free space
cache for block group 2286562574336, rebuilding it now
[  452.619318] BTRFS: open_ctree failed

or it does not mean anything terrible?

--
Best Regards,
Mike Gavrilov.
