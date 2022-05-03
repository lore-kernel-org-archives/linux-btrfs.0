Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66066C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 May 2022 09:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiECJiC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 May 2022 05:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiECJiB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2022 05:38:01 -0400
Received: from ssl1.xaq.nl (ssl1.xaq.nl [45.83.234.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D8F28E32
        for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2022 02:34:29 -0700 (PDT)
Received: from kakofonix.xaq.nl (kakofonix.utr.xaq.nl [192.168.64.105])
        by ssl1.xaq.nl (Postfix) with ESMTPSA id A84F282F95
        for <linux-btrfs@vger.kernel.org>; Tue,  3 May 2022 11:34:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lucassen.org;
        s=202104; t=1651570467;
        bh=rsVN6ba0z1a4JFw155QVSJg4a4U5PIjCrYa3LFJ7Fac=;
        h=Date:From:To:Subject:In-Reply-To:References:Reply-To;
        b=ZrmforANyIJU2k5VECgckbTc09nB9iHxT56/2pd56/6DipEiFeOB6x6hK/yddCymB
         pMQfeTkB/DLLlMfzKjrEwlnn9VoFkHmh63/7vW40YkK7WMlf4k49WDUjnRQctUDS58
         5kLfH9MM9mwdeMYuUgVICV8+HSyj4gdrEZFVvaaUZWvqJLExMoBxKV5+nmhcO8iR/b
         ut8x0YInVYvMT88/4dZ1owOBj3TuxmhLru1tXsVVnNP/5HsDS2d6RVnoTKJSFXgQ+X
         24NEbODVVwwYq1Xx/WBng4oijfJwogEeRI5OSu/3l9EThtocqO0pz5h+g8Hq8UTT7/
         oLuVqPGIs2hnA==
Date:   Tue, 3 May 2022 11:34:27 +0200
From:   richard lucassen <mailinglists@lucassen.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: cannot mount btrfs root partition
Message-Id: <20220503113427.3a192c5daf6197aa3b6c93bc@lucassen.org>
In-Reply-To: <20220503090842.GJ15632@savella.carfax.org.uk>
References: <20220503102001.271842da4933a043ba106d92@lucassen.org>
        <20220503083206.GI15632@savella.carfax.org.uk>
        <20220503104550.16d2465877beb89f713485c2@lucassen.org>
        <20220503090842.GJ15632@savella.carfax.org.uk>
Reply-To: linux-btrfs@vger.kernel.org
Organization: XAQ Systems
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 3 May 2022 10:08:42 +0100
Hugo Mills <hugo@carfax.org.uk> wrote:

>    For the single-drive case, I don't know why that's not working. Is
> the error message the same with that as for the multi-device FS?

Oops, error, mea culpa, it's an SD card and I forgot the "rootwait"
option. It boots into btrfs now!

About the option to specify the devices explicitely, is this the right
syntax to tell the kernel what to do?

append="root=/dev/sda6 rootflags=device=/dev/sda6,device=/dev/sdb6"

R.

-- 
richard lucassen
https://contact.xaq.nl/
