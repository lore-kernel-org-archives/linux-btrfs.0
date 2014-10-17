Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54613 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaJQRI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 13:08:56 -0400
Received: by mail-wi0-f176.google.com with SMTP id hi2so2609936wib.15
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 10:08:54 -0700 (PDT)
Received: from [10.34.184.179] (188.29.164.88.threembb.co.uk. [188.29.164.88])
        by mx.google.com with ESMTPSA id dw9sm168604wib.0.2014.10.17.10.08.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 17 Oct 2014 10:08:53 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Ccache on btrfs
From: Leonidas Spyropoulos <artafinde@gmail.com>
Date: Fri, 17 Oct 2014 18:11:02 +0100
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <2700CF0B-F340-44F7-A4D6-0C5FF05CCD81@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi 

Is there an issue with btrfs ccache and multiple threads during compilation? I'm experiencing kernel panics while building Linux kernel on a btrfs system with -j8 and ccache enabled. Google suggest there was some issue on earlier kernels but my kernel is 3.16+

Anyone can confirm? 

Thanks 
Leonidas 
