Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:41844 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388002AbeGWSrW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 14:47:22 -0400
Subject: Re: Regression with crc32c selection?
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <ca274e95-538c-0c0e-e184-3542b4524afe@applied-asynchrony.com>
 <20180723165040.GP26141@twin.jikos.cz>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <dcbd71c0-e596-ceb3-9eae-11287f9ae74c@applied-asynchrony.com>
Date: Mon, 23 Jul 2018 19:45:02 +0200
MIME-Version: 1.0
In-Reply-To: <20180723165040.GP26141@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/23/18 18:50, David Sterba wrote:
> On Mon, Jul 23, 2018 at 04:13:26PM +0200, Holger Hoffstätte wrote:
>> While backporting a bunch of fixes to my own 4.16.x tree
>> (4.17 had a few too many bugs for my taste) I also ended up merging:
> 
> Curious, bugs in btrfs or the whole 4.17 kernel? And if bugs, real
> breakage or backported fixes?

Overall. I don't remember specifics but skimming lkml at the time
didn't inspire a lot of confidence, and since I already had a large
number of hand-picked & backported patches from 4.17/4.18/4.19 :) for
btrfs, xfs, net, blk-mq & drivers - just the stuff I care about - I skipped
it instead of upgrading & rebasing everything. Might well be that the latest
4.17-stable works reliably, but 4.18 is already around the corner, so..
no really good reason. :)

cheers
Holger
