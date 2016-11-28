Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:60190 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754833AbcK1Scn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 13:32:43 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
References: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
 <94606bda-dab0-e7c9-7fc6-1af9069b64fc@inwind.it>
 <f814eb1b-844b-2ace-c948-3be20da2fd29@cn.fujitsu.com>
 <a75c9a72-148c-9fbd-dfb8-7cde58bee9c9@inwind.it>
 <20161125043119.GG8685@hungrycats.org>
 <cd7ee5cc-d384-7c9c-d656-cef2569b749a@inwind.it>
 <1480304269.6254.6.camel@scientia.net>
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <2b15ae6f-51ce-45ff-47c0-699506de4e56@inwind.it>
Date: Mon, 28 Nov 2016 19:32:38 +0100
MIME-Version: 1.0
In-Reply-To: <1480304269.6254.6.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-28 04:37, Christoph Anton Mitterer wrote:
> I think for safety it's best to repair as early as possible (and thus
> on read when a damage is detected), as further  blocks/devices may fail
> till eventually a scrub(with repair) would be run manually.
> 
> However, there may some workloads under which such auto-repair is
> undesirable as it may cost performance and safety may be less important
> than that.

I am assuming that a corruption is a quite rare event. So occasionally it could happens that a page is corrupted and the system corrects it. This shouldn't  have an impact on the workloads.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
