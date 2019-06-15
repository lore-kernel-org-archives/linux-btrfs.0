Return-Path: <SRS0=kSG/=UO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C28E1C31E51
	for <linux-btrfs@archiver.kernel.org>; Sat, 15 Jun 2019 18:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D0322082C
	for <linux-btrfs@archiver.kernel.org>; Sat, 15 Jun 2019 18:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560623381;
	bh=drg1GKt+ib6Bp6LZP0o/5c5PxF6plAd2lkDNtWcgiCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TDboPXfir2EOIi/Zjy52cP7VlXKOQe5fnY/8OKDUmWeZQMQFglI8+SsdMXveo6Pq+
	 9uID3AaTuh7bzkq/iCjYIPgdLk0PigS8l9ttbE54KV6PIEDG/JUhGnQZoAyQtMigoD
	 5aECGVXplfclkpf2pSXU/rD3zPtczYpgTBifEk5E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfFOS3h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 15 Jun 2019 14:29:37 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45666 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOS3h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jun 2019 14:29:37 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so3795741qkj.12;
        Sat, 15 Jun 2019 11:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lZWCDkdCZYN5S0+Ul2IxfiRO29wLQTcP6wWsFwWlu8s=;
        b=PphbEiU9i51xnvtm9V73bQYuo5cIfkeTXUcMOZ155zwXkW9k1v0AszL3HGTB5AYeTT
         fMmrhBXuFr0sPCV8eoVVlAksctrq0Tp9EfiShBGan9umj+gy1onSVWWyp/YbfNQ8hPO0
         /YFxWG/bnNyKmMK9S+h8oW63Tm9QU2mlTRob+1FyRqmyB1V5pEABc7CIakDbt8CPe9zk
         5OthH7bBlGrWW0NoCY261eL7JxLB03tRJCoGI4wGle7j93IpmuJsT+faKyIQzcXuW9CI
         btceBey/cK2gygHTP53JgjcqvJ2KM9kFr8n+9XEQeuWH9QBQVX9jjMSGKTp/Ed+ovdcz
         DqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=lZWCDkdCZYN5S0+Ul2IxfiRO29wLQTcP6wWsFwWlu8s=;
        b=YrJsVPB46VnybZ6pvHnHjY6HMrSeX/gus1txUHXOwRyDr2FIamXMCsiuWRn3tu9mOV
         hbYjika5yo1yBq4+4L53t5P7VlXGjBxdsHn/G3lAxaVpjcGswnWAvN9Ms5M9Kj+H1wSB
         Z12X0UlNsBt/TCmmm54ish8unSVy7rHsUpv6DKos26iU+jBN+Av82FcyADN5Zu8QvGR9
         3maBS/rENyGssPvbRg8GnQqz1+rwQAluN/V5baMxClAjeJts37hsxNl7r3oTH6iRpg/p
         iYm0Qx342UpkqUgJw+fUPoKP3tgdhDQ2jb4dg9zf6eLXtZLpOnb+UBg8R9EwlqUVObHx
         k+8A==
X-Gm-Message-State: APjAAAXW54WSp2Z5E1QfMNc3UuA3Y2N29aPwwXYL8WbTvzGuA8C5ub8L
        eCo6VsjWRJZwHl1zKCXqYyE=
X-Google-Smtp-Source: APXvYqx5M5Vccns8o0Sb2Ujl3A2MXEaAf0YNJo2yyhXxfxv1/7ALY9MC70OvLseEU3n6ihO/8XZSew==
X-Received: by 2002:a05:620a:124c:: with SMTP id a12mr82297214qkl.336.1560623376408;
        Sat, 15 Jun 2019 11:29:36 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::4883])
        by smtp.gmail.com with ESMTPSA id c5sm4004284qkb.41.2019.06.15.11.29.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Jun 2019 11:29:35 -0700 (PDT)
Date:   Sat, 15 Jun 2019 11:29:33 -0700
From:   Tejun Heo <tj@kernel.org>
To:     dsterba@suse.com, clm@fb.com, josef@toxicpanda.com,
        axboe@kernel.dk, jack@suse.cz
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 4/9] blkcg: implement REQ_CGROUP_PUNT
Message-ID: <20190615182933.GH657710@devbig004.ftw2.facebook.com>
References: <20190615182453.843275-1-tj@kernel.org>
 <20190615182453.843275-5-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190615182453.843275-5-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

On Sat, Jun 15, 2019 at 11:24:48AM -0700, Tejun Heo wrote:
> When a shared kthread needs to issue a bio for a cgroup, doing so
> synchronously can lead to priority inversions as the kthread can be
> trapped waiting for that cgroup.  This patch implements
> REQ_CGROUP_PUNT flag which makes submit_bio() punt the actual issuing
> to a dedicated per-blkcg work item to avoid such priority inversions.
> 
> This will be used to fix priority inversions in btrfs compression and
> should be generally useful as we grow filesystem support for
> comprehensive IO control.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Cc: Chris Mason <clm@fb.com>

The blkcg patches, especially this one, need Jens's review.  Jens, if
you're okay with the changes, please let me know how you want them to
be routed.

Thanks.

-- 
tejun
