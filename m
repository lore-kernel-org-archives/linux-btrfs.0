Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DF5C282C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 18:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C702321019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548267492;
	bh=OHfXKqS/cd5PdeS0hlQomNAdJPyO2rGLTqijJHyb9X4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=bzgiGoE43L0C9WDOPfbJE6Ab4VrfAOODOPsjZHtJQdPKNjojhXhj56hf97LU3CYKM
	 ELuzZi0ZEzHwsX+SDYJFqJTNI/k8dH4lEhostkVWsugOSi+DPXwhLYo1TJwYZkjTEX
	 pg4jWU1WhdTiuEfL/Fh5E6wNfzBE+CY3hvrG5bWY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfAWSSH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 13:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfAWSSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 13:18:07 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6478421019;
        Wed, 23 Jan 2019 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548267486;
        bh=OHfXKqS/cd5PdeS0hlQomNAdJPyO2rGLTqijJHyb9X4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oDEsVf0BiYCdgmuZcW2l3EKh8c1bHNzP0k1o7H9NzSoHl+/xDqIqkb0vDcOEMmrMg
         wvl+LKcgJlRCFRUY4zuw+hT8au1n+cSXN0iGZhCV5eqRP3EDP0cOYTHNRKmTdcQ67N
         IcDegIsyD5V4usq6TB02m/98vboSbaj1P8jPdNgs=
Date:   Wed, 23 Jan 2019 13:18:05 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Message-ID: <20190123181805.GM202535@sasha-vm>
References: <20190108192628.121270-1-sashal@kernel.org>
 <20190108192628.121270-72-sashal@kernel.org>
 <783ccf1f-65df-d388-079c-9449d4319c27@mendix.com>
 <20190123143732.GL202535@sasha-vm>
 <cb62ab8d-7d6f-de02-2912-3d9391a2bbb2@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cb62ab8d-7d6f-de02-2912-3d9391a2bbb2@mendix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 23, 2019 at 03:54:00PM +0000, Hans van Kranenburg wrote:
>On 1/23/19 3:37 PM, Sasha Levin wrote:
>> On Tue, Jan 08, 2019 at 11:52:02PM +0000, Hans van Kranenburg wrote:
>>> Hi Sasha,
>>>
>>> On 1/8/19 8:25 PM, Sasha Levin wrote:
>>>> From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
>>>>
>>>> [ Upstream commit baf92114c7e6dd6124aa3d506e4bc4b694da3bc3 ]
>>>>
>>>> Commit 92e222df7b "btrfs: alloc_chunk: fix DUP stripe size handling"
>>>> fixed calculating the stripe_size for a new DUP chunk.
>>>
>>> That one also ended up as:
>>>
>>> 4.14-stable
>>> 0136bd7238b2cb8238426af4183ed0b02165c3f9
>>>
>>> 4.9-stable
>>> 8890bae03f4dba1c2292e5445682b556af4e8f1b
>>>
>>> 4.4-stable
>>> 97c3e46ef53748278286fc09dcc30b138d6677c4
>>>
>>> 3.16.57-rc1
>>> f68f46284a199f6837c1d5b94a6ae979a2cc463c
>>>
>>> While hitting the failure condition without adding "crafting" steps to
>>> make it exactly match the scenario is unlikely, it might be good if we
>>> just go all the way back with this regression fix?
>>
>> What do you mean with "all the way back"?
>
>Oh, apologies for not using unambigious phrasing.
>
>I mean, it seems the autoselection only found 92e222df7b in places where
>it's actually called 92e222df7b, and not where it was cherry-picked.
>
>So, for my own understanding: If I have to do something like this ever
>again, then should I have added it like this inside baf92114c?
>
>Fixes: 92e222df7b ("btrfs: alloc_chunk: fix DUP stripe size handling")
>Fixes: 0136bd7238 ("btrfs: alloc_chunk: fix DUP stripe size handling")
>Fixes: 8890bae03f ("btrfs: alloc_chunk: fix DUP stripe size handling")
>Fixes: 97c3e46ef5 ("btrfs: alloc_chunk: fix DUP stripe size handling")
>Fixes: f68f46284a ("btrfs: alloc_chunk: fix DUP stripe size handling")
>
>Thanks for your patience, :)

Ah, the scripts have enough "brains" to deal with these on their own, so
no need to annotate that much.

This patch wasn't applied to older trees because it didn't cherry-pick
cleanly on top of them. Looking at it now, it seems to depend on
793ff2c88c6 ("btrfs: volumes: Cleanup stripe size calculation") which
can possibly be picked up if it makes sense.

--
Thanks,
Sasha
