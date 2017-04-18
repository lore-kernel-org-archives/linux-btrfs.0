Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www44.your-server.de ([213.133.104.44]:47049 "EHLO
        www44.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752911AbdDRNBn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 09:01:43 -0400
Received: from [78.47.166.52] (helo=sslproxy04.your-server.de)
        by www44.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.85_2)
        (envelope-from <wb@o3-software.de>)
        id 1d0SS5-00058Y-N0
        for linux-btrfs@vger.kernel.org; Tue, 18 Apr 2017 14:41:49 +0200
Received: from [2a00:12d0:aa03:a601:4223:8bc9:212e:c191] (helo=wb17.fritz.box)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-SHA:256)
        (Exim 4.84_2)
        (envelope-from <wb@o3-software.de>)
        id 1d0SS5-0006IF-G7
        for linux-btrfs@vger.kernel.org; Tue, 18 Apr 2017 14:41:49 +0200
To: linux-btrfs@vger.kernel.org
From: Werner Braun <wb@o3-software.de>
Subject: btrfs check --check-data-csum malfunctioning?
Message-ID: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de>
Date: Tue, 18 Apr 2017 14:41:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i have a WD WD40EZRX with strange beaviour off btrfs check vs. btrfs scrub

running btrfs check --check-data-csum returns no errors on the disk

running btrfs scrub on the disk finds tons of errors

i could clear the disk and send it to anyone intrested in ;-)


-- 
Werner Braun
+49 178 145 8768

O³ Software GmbH & Co. KG * Franziusallee 73 * 24148 Kiel * Germany
Sitz der Gesellschaft Kiel * HR Amtsgericht Kiel HRA 6418 KI
Persönlich haftende Gesellschafterin: O³ Software GmbH
HR Amtsgericht Kiel HRB 10335 KI * Geschäftsführer Werner Braun
