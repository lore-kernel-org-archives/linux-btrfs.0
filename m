Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FC3ECDE44
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 19:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08CBC2081D
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 19:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08CBC2081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cs.uni-bonn.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbeKEEeV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 4 Nov 2018 23:34:21 -0500
Received: from smtp8.iai.uni-bonn.de ([131.220.63.194]:44941 "EHLO
        smtp8.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbeKEEeV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Nov 2018 23:34:21 -0500
X-IAI-Env-From: <ochmann@cs.uni-bonn.de> : [127.0.0.1]
Received: from smtp8.iai.uni-bonn.de (smtp8.iai.uni-bonn.de [127.0.0.1])
        by smtp8.iai.uni-bonn.de (Postfix) with ESMTP id 7BDD9E4DC;
        Sun,  4 Nov 2018 20:18:11 +0100 (MET)
        (envelope-from ochmann@cs.uni-bonn.de)
        (envelope-to VARIOUS) (2)
X-IAI-Env-From: <ochmann@cs.uni-bonn.de> : [91.10.4.29]
Received: from [192.168.0.1] (p5B0A041D.dip0.t-ipconnect.de [91.10.4.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: ochmann@auth.iai.uni-bonn.de)
        by smtp8.iai.uni-bonn.de (Postfix) with ESMTPSA id 5494AE4DB;
        Sun,  4 Nov 2018 20:18:11 +0100 (MET)
        (envelope-from ochmann@cs.uni-bonn.de)
        (envelope-to VARIOUS) (2)
        (internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
X-IAI-Auth: +fgJSkcTN/RyTAJXgShQ5oMcOt4qQIWirxUBAU531LmUjCgdwd19vqparQ1pnrrhCTJlMyTTiF6wVVgDlqnBZwzVfavYino8DRGTvSsYavcGJGOvffCxvgAAAAAAAAAA@auth.iai.uni-bonn.de
Subject: Re: Filesystem mounts fine but hangs on access
To:     Duncan <1i5t5.duncan@cox.net>
References: <20181104113137.3ca6043e@ws>
Cc:     linux-btrfs@vger.kernel.org
From:   Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Message-ID: <6d5dc8a3-e66c-e38f-49cb-c95ea2aef777@cs.uni-bonn.de>
Date:   Sun, 4 Nov 2018 20:18:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181104113137.3ca6043e@ws>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 04.11.18 19:31, Duncan wrote:
> [This mail was also posted to gmane.comp.file-systems.btrfs.]
> 
> Sebastian Ochmann posted on Sun, 04 Nov 2018 14:15:55 +0100 as
> excerpted:
> 
>> Hello,
>>
>> I have a btrfs filesystem on a single encrypted (LUKS) 10 TB drive
>> which stopped working correctly.
> 
>> Kernel 4.18.16 (Arch Linux)
> 
> I see upgrading to 4.19 seems to have solved your problem, but this is
> more about something I saw in the trace that has me wondering...
> 
>> [  368.267315]  touch_atime+0xc0/0xe0
> 
> Do you have any atime-related mount options set?

That's an interesting point. On some machines, I have explicitly set 
"noatime", but on that particular system, I did not, thus using the 
"relatime" option as per default. Since I'm not using mutt or anything 
else (that I'm aware of) that exploits this feature, I will set noatime 
there as well.

> FWIW, noatime is strongly recommended on btrfs.
> 
> Now I'm not a dev, just a btrfs user and list regular, and I don't know
> if that function is called and just does nothing when noatime is set,
> so you may well already have it set and this is "much ado about
> nothing", but the chance that it's relevant, if not for you, perhaps
> for others that may read it, begs for this post...
> 
> The problem with atime, access time, is that it turns most otherwise
> read- only operations into read-and-write operations in ordered to
> update the access time.  And on copy-on-write (COW) based filesystems
> such as btrfs, that can be a big problem, because updating that tiny
> bit of metadata will trigger a rewrite of the entire metadata block
> containing it, which will trigger an update of the metadata for /that/
> block in the parent metadata tier... all the way up the metadata tree,
> ultimately to its root, the filesystem root and the superblocks, at the
> next commit (normally every 30 seconds or less).
> 
> Not only is that a bunch of otherwise unnecessary work for a bit of
> metadata barely anything actually uses, but forcing most read
> operations to read-write obviously compounds the risk for all of those
> would-be read- only operations when a filesystem already has problems.
> 
> Additionally, if your use-case includes regular snapshotting, with
> atime on, on mostly read workloads with few writes (other than atime
> updates), it may actually be the case that most of the changes in a
> snapshot are actually atime updates, making reoccurring snapshot
> updates far larger than they'd be otherwise.
> 
> Now a few years ago the kernel did change the default to relatime,
> basically updating the atime for any particular file only once a day,
> which does help quite a bit, and on traditional filesystems it's
> arguably a reasonably sane default, but COW makes atime tracking enough
> more expensive that setting noatime is still strongly recommended on
> btrfs, particularly if you're doing regular snapshotting.
> 
> So do consider adding noatime to your mount options if you haven't done
> so already.  AFAIK, the only /semi-common/ app that actually uses
> atimes these days is mutt (for read-message tracking), and then not for
> mbox, so you should be safe to at least test turning it off.
> 
> And YMMV, but if you do use mutt or something else that uses atimes,
> I'd go so far as to recommend finding an alternative, replacing either
> btrfs (because as I said, relatime is arguably enough on a traditional
> non-COW filesystem) or whatever it is that uses atimes, your call,
> because IMO it really is that big a deal.
> 
> Meanwhile, particularly after seeing that in the trace, if the 4.19
> update hadn't already fixed it, I'd have suggested trying a read-only
> mount, both as a test, and assuming it worked, at least allowing you to
> access the data without the lockup, which would have then been related
> to the write due to the atime update, not the actual read.

It would be nice to have a 1:1 image of the filesystem (or rather the 
raw block device) for more testing, but unfortunately I don't have 
another 10 TB drive lying around. :) I didn't really expect the 4.19 
upgrade to (apparently) fix the problem right away, so I also couldn't 
test the mentioned patch, but yeah... If it happens again (which for 
some reason I don't hope), I'll try you suggestion.

> Actually, a read-only mount test is always a good troubleshooting step
> when the trouble is a filesystem that either won't mount normally, or
> will, but then locks up when you try to access something.  It's far
> lest risky than a normal writable mount, and at minimum it provides you
> the additional test data of whether it worked or not, plus if it does,
> a chance to access the data and make sure your backups are current,
> before actually trying to do any repairs.
> 
