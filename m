Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033C3C2FC14
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Aug 2023 13:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351602AbjHQN5J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351605AbjHQN4o (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2023 09:56:44 -0400
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D08D2D4A;
        Thu, 17 Aug 2023 06:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8PNKj+kp8EyIMqzQVVevezf3wUHSsn+bPElvLm2rfWg=; b=m3yUE4oYox7e/vxsnFZJZRNWeA
        EBb7ZzsOO5Hg1ZENoLt82kn6IIyz26sfXpCsbCILWrHfF5zQ6gLyxHcCwhSoBRdVwiwRgyFKq2+A0
        uHWBw6Kn9kr9AuF8Vl7C2kqVjPc1NtwigK0wO6ooQTzHInpNXFIQWXZDVVjkarTFhBvQA5ICzv4U1
        b4aJE0WXw2RS8jeY1NU+2Rz9T09MedeQcDkYpEXX0hYvNyUg+1nSG3ysIpvSj+LbScWcjN3HI2+2X
        IIna8rZdkzFQ8xBRqV3eiqJec8/zJ4Yv6kwjywpE38UW46m6kS4okaWlBfNNhZt6uGlmi2z9lhtht
        mP8OooXg==;
Received: from 201-92-22-215.dsl.telesp.net.br ([201.92.22.215] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1qWdUK-001w99-NH; Thu, 17 Aug 2023 15:56:36 +0200
Message-ID: <d628aa41-ce6c-4fbc-442f-e6322dbb24f4@igalia.com>
Date:   Thu, 17 Aug 2023 10:56:26 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH V2 0/3] Supporting same fsid mounting through a compat_ro
 feature
To:     dsterba@suse.com
Cc:     clm@fb.com, linux-btrfs@vger.kernel.org, josef@toxicpanda.com,
        linux-fsdevel@vger.kernel.org, kernel@gpiccoli.net,
        kernel-dev@igalia.com, anand.jain@oracle.com, david@fromorbit.com,
        kreijack@libero.it, johns@valvesoftware.com,
        ludovico.denittis@collabora.com, quwenruo.btrfs@gmx.com,
        wqu@suse.com, vivek@collabora.com
References: <20230803154453.1488248-1-gpiccoli@igalia.com>
Content-Language: en-US
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20230803154453.1488248-1-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 03/08/2023 12:43, Guilherme G. Piccoli wrote:
> Hi all, this is the 2nd attempt of supporting same fsid mounting
> on btrfs. V1 is here:
> https://lore.kernel.org/linux-btrfs/20230504170708.787361-1-gpiccoli@igalia.com/
> 
> The mechanism used to achieve that in V2 was a mix between the suggestion
> from JohnS (spoofed fsid) and Qu (a single-dev compat_ro flag) - it is
> still based in the metadata_uuid feature, leveraging that infrastructure
> since it prevents lots of corner cases, like sysfs same-fsid crashes.
> 
> The patches are based on kernel v6.5-rc3 with Anand's metadata_uuid refactor
> part 2 on top of it [0]; the btrfs-progs patch is based on "v6.3.3".
> 
> Comments/suggestions and overall feedback is much appreciated - tnx in advance!
> Cheers,
> 
> Guilherme
> 
> 
> [0] https://lore.kernel.org/linux-btrfs/cover.1690792823.git.anand.jain@oracle.com/
> 
> 
> Guilherme G. Piccoli (3):
>   btrfs-progs: Add the single-dev feature (to both mkfs/tune)
>   btrfs: Introduce the single-dev feature
>   btrfs: Add parameter to force devices behave as single-dev ones


Hi David, friendly ping about this one - do you think we could have it
merged, or do you have suggestions to improve it maybe?

Thanks in advance and apologies for the ping!
Cheers,


Guilherme


