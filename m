Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4318DC282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 14:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 098E7217D4
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 14:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548254259;
	bh=hcpv+fxe0oQ8iM8Kl4aiogpTMvxmAnW+WTp1TpW5C7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Mc11c2p3jW4r3VSNQ5KnsCYXVnV62MCbp32UmmKlQ3PCWKDofJwiySZgHK2esSBgh
	 5ratc9hCFid1VXSGZa59i9/6V+TnnlvY1yR2kBwmNr1HRyFDfN7miSabzRqL00GEX5
	 OJn14/wQIwx/fpl8PDN9dUX5Din37iYnSOzxyfO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfAWOhe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 09:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfAWOhe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 09:37:34 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116472085A;
        Wed, 23 Jan 2019 14:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548254253;
        bh=hcpv+fxe0oQ8iM8Kl4aiogpTMvxmAnW+WTp1TpW5C7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1BP6nq6wMVtzuTuOW2e0zEWlhwJhwqSL5MrWc7Tmk/nRRCeoHyRWhE+gvwuolN0Lr
         pSSDCymnF6w6u1DL3F91MEfSIYNOwqclVW0qDmCX6S7y5wC81a9j2Ad4a5TfRMfK3f
         iXjAmjR1DwGoYyY1Jd7XWma+fk287IzlkJsot+cw=
Date:   Wed, 23 Jan 2019 09:37:32 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.20 072/117] btrfs: alloc_chunk: fix more DUP
 stripe size handling
Message-ID: <20190123143732.GL202535@sasha-vm>
References: <20190108192628.121270-1-sashal@kernel.org>
 <20190108192628.121270-72-sashal@kernel.org>
 <783ccf1f-65df-d388-079c-9449d4319c27@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <783ccf1f-65df-d388-079c-9449d4319c27@mendix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 08, 2019 at 11:52:02PM +0000, Hans van Kranenburg wrote:
>Hi Sasha,
>
>On 1/8/19 8:25 PM, Sasha Levin wrote:
>> From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
>>
>> [ Upstream commit baf92114c7e6dd6124aa3d506e4bc4b694da3bc3 ]
>>
>> Commit 92e222df7b "btrfs: alloc_chunk: fix DUP stripe size handling"
>> fixed calculating the stripe_size for a new DUP chunk.
>
>That one also ended up as:
>
>4.14-stable
>0136bd7238b2cb8238426af4183ed0b02165c3f9
>
>4.9-stable
>8890bae03f4dba1c2292e5445682b556af4e8f1b
>
>4.4-stable
>97c3e46ef53748278286fc09dcc30b138d6677c4
>
>3.16.57-rc1
>f68f46284a199f6837c1d5b94a6ae979a2cc463c
>
>While hitting the failure condition without adding "crafting" steps to
>make it exactly match the scenario is unlikely, it might be good if we
>just go all the way back with this regression fix?

What do you mean with "all the way back"?

--
Thanks,
Sasha
