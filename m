Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97813C7EE2F
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Jun 2023 14:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjFJOlB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Jun 2023 10:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjFJOlB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Jun 2023 10:41:01 -0400
X-Greylist: delayed 348 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 10 Jun 2023 07:40:59 PDT
Received: from mail.render-wahnsinn.de (unknown [IPv6:2a01:4f8:13b:3d57::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E9D30ED
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jun 2023 07:40:59 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 6A22C342289
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jun 2023 16:35:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=render-wahnsinn.de;
        s=dkim; t=1686407708; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:content-language;
        bh=066VQDYK4e6aZF9iFMzBgvlddXUuQ6c1SOjcOaiZ7NM=;
        b=VUEYMxfh/VbR9Dc5W7GpKDJbMILl53yzUeG8zPdIpkFPJ03m2W2ILIS9bQODIjIVu1eV/K
        gWV7VqDp/KjdXRRNFx8dWPEm9gkvrURJWnQIx/YBTojTnE3MsRvfzYUr/s7bjy2peC8aWq
        Tx4S9zsj/0B9G0rt1qVf0wMeiJ2qKk6sXhoGS3BpqlrwRgCzCZODjzGkH1+7hmYAa5YSOd
        1Y3EnyepeLQ2gXEseUA/BUGMB19cP9LZhFAuaiDDoNxc9qr8OE/hSFjbb8aAz6kre4bJo3
        RC01Aav/MyRv8DtwoGjuExHAI/df4O2aaJE/QfMBSPX0gvX6i/41zIqOH4qiiA==
Message-ID: <84574a65-e405-237c-bd0f-834a5254ba3e@render-wahnsinn.de>
Date:   Sat, 10 Jun 2023 16:35:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Language: en-US
From:   Robert Krig <robert.krig@render-wahnsinn.de>
Subject: Is there a performance difference between RAID10 and RAID1C4 for
 metadata?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi.


I have a BTRFS RAID10 Array, which consists of 8 disks that have the 
same size.
I'm using Raid1C4 for the metadata.

Would there be any performance benefits for converting metadata to RAID10?
Are there any drawbacks, e.g. would it make the FS less resilient?

