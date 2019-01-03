Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AC1C43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:27:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18CDB2073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:27:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfW0hlRz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbfACH1q (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:27:46 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:35580 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfACH1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 02:27:46 -0500
Received: by mail-wr1-f45.google.com with SMTP id 96so32688000wrb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jan 2019 23:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YPFubw9pIF4dx2GJRaFGJxfBnUofhsDnkpvQ9+dQseU=;
        b=NfW0hlRz7073RdFmmDjGFytVbB+FjbdP/Od7U3ulTOhAahthiULfzY8jKa9akHBv1U
         l3d2ay80jTdaWk1nx6o7TRT54flkuAq7YC9HLvs/LpBzqKCicDrRJOR5sLTpWYSoaqH7
         me2lsi2c3pwe1SK0lowyF9s4BhYxA8J0LVOL7g+wGZjFHB3IDt8aIq/o/E3m9aIzlRdS
         kWHcY9Rnqe9LT2GLZAY3W1X6bVD5LCrZdnncqPvXPz666nhiMS3nEKs6jqWrCnOKz5Is
         AsWBwUZY6y0E7aUIaP1hGusqeEQ+HczjvTrNcHY7cIs1swgCqAC+AtBaCHsuPawd0KTy
         WvXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=YPFubw9pIF4dx2GJRaFGJxfBnUofhsDnkpvQ9+dQseU=;
        b=EQV6ZTfXlFgAaihmu+2turKSrzoz9TtH9irexuBtkG8VledXIblaneepQtg/mLPo6u
         /NIWTg0DV07w0HFwVLMD2r58pX03nP3e6I4UeuAWqOd+NNj/ax9flH8WHXF/gQA536aK
         KxTC6j8VmR7uqA2sHe4KYYm0DXzRP6N7SNQP52gIbmobjkc4R4ooYS4I2NQEaLy8pTE4
         SRtON461/IUNkvjWnM3UzArZrRlobtLCDoCVdik2wrVEkTsF3PFWvQry9XAVJdTnH3Wh
         s6f4eLwB5I+X30VC6aIJJ+uzuQyctZSg8lP+zCiixxeq4uZIhkc14+38ols7Maxd3tzJ
         7Ssw==
X-Gm-Message-State: AJcUukfFbcrVxPu55Il+ELRrLE/GLY17vXtdnq4ad2mu1vPGFBd+deUE
        ZPobBskLI+NAEgCLPaMywfh2QVeqFAI=
X-Google-Smtp-Source: ALg8bN5K9WxeyVE6S7mX+iXSnUdhtf+oHNlwvpz2lSPDyhhtQo0IzD5BknMAjZB8SHvZ1vU4bjpKCg==
X-Received: by 2002:a5d:4d87:: with SMTP id b7mr38257660wru.316.1546500464246;
        Wed, 02 Jan 2019 23:27:44 -0800 (PST)
Received: from glet ([91.187.202.82])
        by smtp.gmail.com with ESMTPSA id 202sm50958652wmt.8.2019.01.02.23.27.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 02 Jan 2019 23:27:43 -0800 (PST)
Date:   Thu, 3 Jan 2019 08:27:40 +0100
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     Tomasz Chmielewski <tch@virtall.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        b11g <b11g@protonmail.com>
Subject: Re: BTRFS corruption: open_ctree failed
Message-ID: <20190103072740.GA64625@glet>
References: <155a0e09f60a0605802c459a6e119b36@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155a0e09f60a0605802c459a6e119b36@virtall.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 11:52:05AM +0900, Tomasz Chmielewski wrote:
> Did you use 4.19.x kernels earlier than 4.19.8?
> 
> They had a bug which would corrupt filesystems (mostly ext4 users would be
> reporting it, but I saw it with other filesystems, like xfs and btrfs, too):

Well, just for the record, it triggers when you have 
scsi devices using elevator=none over blkmq.

And it's not a default/usual configuration.

So, b11g, can you check please if the NixOS kernel is compiled with these flags?
And/or if they have something like:
scsi_mod.use_blk_mq=1
in the boot command line?

Ciao,
Gelma
