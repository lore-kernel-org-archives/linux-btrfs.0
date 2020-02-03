Return-Path: <SRS0=25Zt=3X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A44AC3524D
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Feb 2020 22:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 258032086A
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Feb 2020 22:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580767244;
	bh=FS3+zcIq9vRjfPIEGimk0dwflndvQTLHJeH8VhY+sIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ioVg2Sr7bl204vTlMod0Vf6hGYApK0zmMgHXp5Z5cFyHMUq5qBCcEHpnmk3JxHPsb
	 7H9b+xiYP7TdAsNoq16d6PeiVtGqUv0w0ySWR7mkK9XrxocHj8qQ/o96xOUBJQnwkX
	 mPxW8UzKB/NW85XBOebgTZGvFAB0OBHujWAkCI40=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgBCWAn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 17:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgBCWAn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Feb 2020 17:00:43 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 506012084E;
        Mon,  3 Feb 2020 22:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580767242;
        bh=FS3+zcIq9vRjfPIEGimk0dwflndvQTLHJeH8VhY+sIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmLQCC6s2uvKL+xFeLTk8E2306JBO0ihQqpvIe+wIcLDueqqLouK1pQmOJEGQovMS
         wkDeJCgPbqvQ2uWe5TMSTuqVCozO8izIY57mIJ8Km48kyXha6tSiUJloVRN8HujXz/
         l4uo9o9FKI7hbdkcNkbKRKU95+f6cXhMZ5Bo1B1w=
Date:   Mon, 3 Feb 2020 17:00:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <greg@kroah.com>
Cc:     dsterba@suse.cz, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: Please add d55966c4279bfc6 to 5.4.x and 5.5.x
Message-ID: <20200203220041.GA31482@sasha-vm>
References: <20200203182949.GD2654@twin.jikos.cz>
 <20200203195007.GA3853072@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200203195007.GA3853072@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 03, 2020 at 07:50:07PM +0000, Greg KH wrote:
>On Mon, Feb 03, 2020 at 07:29:49PM +0100, David Sterba wrote:
>> Hi,
>>
>> I'd like to ask the stable team to add the patch
>>
>> d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6
>> btrfs: do not zero f_bavail if we have available space
>>
>> to 5.4 and 5.5 stable trees as early as possible.
>>
>> I'm not familiar with your release schedules but I saw the large patch
>> sets for review and I hope I could squeeze that one in the upcoming
>> release.
>>
>> The commit fixes a problem in 'df' that causes false alerts and there
>> are a lot of users hitting it. The patch itself is a one-liner, but
>> with a high impact on usability.
>
>I've snuck it in now, and if you could provide a backport for 4.4.y,
>that would be great as I think it's also needed there.

To help my OCD I snuck it in to 4.4 as well, it just depended on
ae02d1bd0707 ("btrfs: fix mixed block count of available space") which
is a fix on it's own.

-- 
Thanks,
Sasha
