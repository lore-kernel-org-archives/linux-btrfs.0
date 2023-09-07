Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45163EC873E
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Sep 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241783AbjIGPff (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 11:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344222AbjIGPcm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Sep 2023 11:32:42 -0400
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BDC1BF;
        Thu,  7 Sep 2023 08:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Moo8y+fyZCd1KYkspxGFRU4h9hAwFKFLft1tLgBc2oI=; b=Hr5j8Diq5/wQ/xxCbcaS/B826T
        ruZBnOLpP500r97p0SzeUmKwxSegPPdm+YJcuTDlqsi5riDMaxkmy0sZZpxn9O3edVRaTN8OTmWLF
        aQKia4ElA2U9IsC6BQGzXtPtbSb7vByI9KKkfiiTPm/3+Up5id2Rx6FeqOZhUEu+inFCO8StkLbOJ
        DACUulJW8BzbSUVzdG4tws9iuFDnOUv9UzuCxl20z8HExSw+I13KPeHI70zzPjM7ysmxuhNFkSKpD
        +JkrqOY3BPEVbj9eKbTbMmJHu5hgsKGJctW1wf9a4xDc0QfYvgVUSDAYPfc9DxbTFbbg8yipZjYgg
        aYxaWCbg==;
Received: from [179.232.147.2] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1qeGxr-000ZsH-4X; Thu, 07 Sep 2023 17:30:38 +0200
Message-ID: <e2c88e77-5f44-5dbc-da1a-41283216c0e8@igalia.com>
Date:   Thu, 7 Sep 2023 12:30:33 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v2] btrfs: Add test for the single-dev feature
Content-Language: en-US
To:     Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        dsterba@suse.com, kernel@gpiccoli.net, kernel-dev@igalia.com
References: <20230905200826.3605083-1-gpiccoli@igalia.com>
 <20230906141733.GC1877831@perftesting>
 <e63f7f76-c039-1bfd-84ea-b8e76be39a86@oracle.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <e63f7f76-c039-1bfd-84ea-b8e76be39a86@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 06/09/2023 11:45, Anand Jain wrote:
> 
> Further to Josef's review.
> 

Thanks both Anand and Josef, I'll implement all the changes in the next
iteration, hopefully having then the proper name for the feature
(instead of single-dev heh).

Cheers,


Guilherme
