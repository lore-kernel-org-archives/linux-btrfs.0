Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.first-world.info ([87.98.163.78]:45984 "EHLO
        smtp.first-world.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752400AbdEJXkC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 19:40:02 -0400
Received: from [192.168.158.10] (unknown [192.223.110.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.first-world.info (Postfix) with ESMTPSA id B5A572D5F8A0
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 01:40:00 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: alpha_one_x86 <alpha_one_x86@first-world.info>
Subject: errno=-28 No space left, with kernel backtrace (blocking bug)
Message-ID: <b780be0e-a8cf-ccb8-b6e1-0563ec9c5910@first-world.info>
Date: Thu, 11 May 2017 01:39:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, this bug is very blocking for me:

https://bugzilla.kernel.org/show_bug.cgi?id=195257

The server is backup server, I btrfs receive (with and without -p), and
of course btrfs subvolume delete
The volume is 70TB, then I use space_cache=v2

Cheers,


-- 
alpha_one_x86/BRULE Herman <alpha_one_x86@first-world.info>
Main developer of Supercopier/Ultracopier/CatchChallenger, Esourcing and server management
IT, OS, technologies, research & development, security and business department

