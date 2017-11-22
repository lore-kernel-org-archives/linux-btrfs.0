Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:44972 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdKVTyN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 14:54:13 -0500
Received: by mail-wm0-f51.google.com with SMTP id r68so12745216wmr.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 11:54:13 -0800 (PST)
Received: from debox (bzq-109-65-163-184.red.bezeqint.net. [109.65.163.184])
        by smtp.gmail.com with ESMTPSA id e131sm2894905wmg.15.2017.11.22.11.54.11
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Nov 2017 11:54:11 -0800 (PST)
Message-ID: <1511380450.1675.94.camel@gmail.com>
Subject: notification about corrupt files from "btrfs scrub" in cron
From: ST <smntov@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Wed, 22 Nov 2017 21:54:10 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have following cron job to scrub entire root filesystem (total ca.
7.2TB and 2.3TB of them used) once a week:
/bin/btrfs scrub start -r / > /dev/null

Such scrubbing takes ca. 2 hours. How should I get notified that a
corrupt file was discovered? Does this command return some error code
back to cron so it can send an email as usual? Will cron wait 2 hours to
get that code?

I tried that command once without "> /dev/null" but got no email
notification about the results (eventhough the check was OK) - why?

Thank you.

