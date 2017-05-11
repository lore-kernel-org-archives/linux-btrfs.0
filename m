Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.first-world.info ([87.98.163.78]:55496 "EHLO
        smtp.first-world.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756475AbdEKPZg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 11:25:36 -0400
Received: from [192.168.158.10] (unknown [192.223.110.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.first-world.info (Postfix) with ESMTPSA id 80FF12D796BC
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 17:25:34 +0200 (CEST)
Subject: Re: errno=-28 No space left, with kernel backtrace (blocking bug)
To: linux-btrfs@vger.kernel.org
References: <b780be0e-a8cf-ccb8-b6e1-0563ec9c5910@first-world.info>
From: alpha_one_x86 <alpha_one_x86@first-world.info>
Message-ID: <003dca87-5ed1-4095-3bcf-c975543cd3ab@first-world.info>
Date: Thu, 11 May 2017 17:25:32 +0200
MIME-Version: 1.0
In-Reply-To: <b780be0e-a8cf-ccb8-b6e1-0563ec9c5910@first-world.info>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Up plz, I can work with this bug.


On 05/11/17 01:39, alpha_one_x86 wrote:
> Hi, this bug is very blocking for me:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=195257
>
> The server is backup server, I btrfs receive (with and without -p), and
> of course btrfs subvolume delete
> The volume is 70TB, then I use space_cache=v2
>
> Cheers,
>
>

-- 
alpha_one_x86/BRULE Herman <alpha_one_x86@first-world.info>
Main developer of Supercopier/Ultracopier/CatchChallenger, Esourcing and server management
IT, OS, technologies, research & development, security and business department

