Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4936CC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 18:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A1E6208E7
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 18:40:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rdcsafety-com.20150623.gappssmtp.com header.i=@rdcsafety-com.20150623.gappssmtp.com header.b="kMLxOGjc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A1E6208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rdcsafety.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbeKPEsx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 23:48:53 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:44633 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbeKPEsx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 23:48:53 -0500
Received: by mail-pg1-f182.google.com with SMTP id t13so736485pgr.11
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 10:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rdcsafety-com.20150623.gappssmtp.com; s=20150623;
        h=reply-to:to:from:subject:organization:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=1z/lZ0kPK2kleapIwGi+JZ1s4bOMrJTIk5dpV/8A22U=;
        b=kMLxOGjcWnMNTe90nGV5aUKBODm3ly5VI+DFkXJg/71Zj7QGCw7hcvpgMN8fInp3fM
         h8OzEIDxi24ERuOtxJiWlBf65Avw/UMFppAhjzeFHSBf74bLR4SR4Jp7ICOzDhiUTx7i
         BZOTCFJWJIEhNoyPSLwUE2Fk+vEBDuYG1I6qI9Wpz7eeFsSk5bbGaT64Om7FhF0UQxac
         iLv59O0NQJcg1/Jmd5tiylJHv2teTGUw3oQU0f8kYHr4ZSJvb+GRCx0DJtiTCUB3UqkK
         +8nKuts0eEiA4SEM7jDoO3sQ0YUdrzUxCmrMh0lA6LUo6lq673xzWLEvbCVp8qbHmBEw
         OxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:to:from:subject:organization:message-id
         :date:user-agent:mime-version:content-transfer-encoding
         :content-language;
        bh=1z/lZ0kPK2kleapIwGi+JZ1s4bOMrJTIk5dpV/8A22U=;
        b=LH61EqcIjD+ximlSeZfqEs2C+6JTF/WjLJ44RdFAIt9PYc9wuRA1ArgPbXYNlHB1n6
         RsUgCPjMyF2ZDs8W2QV7sTu2Jy+D/H04kGv7Ah/DcZo5+pmNHwBwuVqrD6lVuOBJmIvp
         amVT0AJl122tEbOYqkXtw4cMUOZLAc1NaJ7RI0Vj1jv4pmo4olpoKRj1joubNcoWqr4G
         iTTqJGuDvweTuI3l98S238xBweUn0XM8DNEzkcdQ+3WhBj805Gm9ts2arOzB0jg1rnmc
         D/8OUa0eyeN2YkjNhvc/+rCklBArvFMlH8et/VBwDP/1V8736AthNzLtiik5sHDXxyAh
         EO7Q==
X-Gm-Message-State: AGRZ1gIMD7nNZsV57x9WVOpxls9mtHRSZZ6P9SqLvUVg4UnNmS4VM4ca
        F/25rEXUkM9KtTP+CrMGIuTQQcXC0UI=
X-Google-Smtp-Source: AJdET5efK0tdUM4DHsXPB7w0a4dG67ZKvL1digIwvKoIp+9MldgBVIGoqOBZxyREOWLOLVBkH4tXPA==
X-Received: by 2002:a63:ef0b:: with SMTP id u11-v6mr6852803pgh.283.1542307197444;
        Thu, 15 Nov 2018 10:39:57 -0800 (PST)
Received: from [192.168.3.92] (S0106a8c7ddf0eb43.fm.shawcable.net. [50.65.49.17])
        by smtp.gmail.com with ESMTPSA id v12-v6sm37263082pfa.167.2018.11.15.10.39.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Nov 2018 10:39:56 -0800 (PST)
Reply-To: jacirez@rdcsafety.com
To:     linux-btrfs@vger.kernel.org
From:   Juan Alberto Cirez <jacirez@rdcsafety.com>
Subject: BTRFS on production: NVR 16+ IP Cameras
Organization: RDC Safety Plus, Inc.
Message-ID: <bf338fb1-11fe-baea-4099-af9dc267e597@rdcsafety.com>
Date:   Thu, 15 Nov 2018 11:39:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Is BTRFS mature enough to be deployed on a production system to underpin 
the storage layer of a 16+ ipcameras-based NVR (or VMS if you prefer)?

Based on our limited experience with BTRFS (1+ year) under the above 
scenario the answer seems to be no; but I wanted you ask the community 
at large for their experience before making a final decision to hold off 
on deploying BTRFS on production systems.

Let us be clear: We think BTRFS has great potential, and as it matures 
we will continue to watch its progress, so that at some future point we 
can return to using it.

The issue has been the myriad of problems we have encountered when 
deploying BTRFS as the storage fs for the NVR/VMS in cases were the 
camera count exceeds 10: Corrupted file systems, sudden read-only file 
system, re-balance kernel panics, broken partitions, etc.

One specific case saw the btrfs drive pool mounted under the /var 
partition so that upon installation the btrfs pool contained all files 
under /var; /lib/mysql as well as the video storage. Needless to say 
this was a catastrophe...

At the other end of the spectrum is a use case where ONLY the video 
storage was on the btrfs pool; but in that case, the btrfs pool became 
read-only suddenly and would not re-mount as rw despite all the recovery 
trick btrfs-tools could throw at it. This, of course prevented the 
NVR/VMS from recording any footage.

So, again, the question is: is BTRFS mature enough to be used in such 
use case and if so, what approach can be used to mitigate such issues.


Thank you all for your assistance

-Ryan-
-- 
Ryan Burt, B. Sc. for
Juan Alberto Cirez, CFPT
