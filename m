Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D65C65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 23:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 069F120672
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544656097;
	bh=9QTpXwPfVl3V44G2/lGacNO0bHfXdb35aRFOtbPNh0w=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=j8ECnIg2ph09PqsUcZd6w23vV14wEFBoTplkAX328qSEsmwgbE5AEltOzhrHYDPrk
	 i0GbRMRdDYqWBGf1nTiAG29slUwvFuDbC4qadKuKKjyQVuxR55MuZLgD2YaCCuuoHO
	 9zihf3Fzc3bNfsUyBwB0sgJB2tY909pv6HojUVkM=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 069F120672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbeLLXIM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 18:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:43578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbeLLXIK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 18:08:10 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDE5D21104;
        Wed, 12 Dec 2018 23:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544656090;
        bh=9QTpXwPfVl3V44G2/lGacNO0bHfXdb35aRFOtbPNh0w=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=wzgmNxhZ14hvziqr9hhN2J/eqmvVr+cdB+U7Q5v8aXgdjYNRUXdH7fEzqN54h6uV5
         aLdD9ee/iIz4qBWH33qd3psze5dIyTGvURe44i4T1+EOCl85YHowFb3lAnT6Wwrajc
         33qmFv5hJXKifenKEjeyYWxNJuqw3JfFigk72hFs=
Date:   Wed, 12 Dec 2018 18:08:08 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robbie Ko <robbieko@synology.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 052/123] Btrfs: send, fix infinite loop due
 to directory rename dependencies
Message-ID: <20181212230808.GF2746@sasha-vm>
References: <20181205093555.5386-1-sashal@kernel.org>
 <20181205093555.5386-52-sashal@kernel.org>
 <20181206175518.GC23615@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20181206175518.GC23615@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 06, 2018 at 06:55:19PM +0100, David Sterba wrote:
>On Wed, Dec 05, 2018 at 04:34:44AM -0500, Sasha Levin wrote:
>> From: Robbie Ko <robbieko@synology.com>
>>
>> [ Upstream commit a4390aee72713d9e73f1132bcdeb17d72fbbf974 ]
>...
>>
>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>> [Wrote changelog with example and more clear explanation]
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Ack for taking this patch to the stable trees. Thanks.

Thanks David.

--
Thanks,
Sasha
