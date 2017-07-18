Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpgw02.sap-ag.de ([155.56.66.97]:5833 "EHLO smtpgw.sap-ag.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751348AbdGRHcO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Jul 2017 03:32:14 -0400
From: "Brennecke, Simon" <simon.brennecke@sap.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-cleaner causing heavy load
Date: Tue, 18 Jul 2017 07:32:12 +0000
Message-ID: <01055d4a71cd4e56a37485ebc3c8c7e9@sap.com>
References: <64e68f94963a441db087e660e167a2f4@sap.com>,<pan$353c4$27c16fdf$380479ed$1d3824d4@cox.net>,<d117be0bcbf641fb8f254911d3bf7ef8@sap.com>
In-Reply-To: <d117be0bcbf641fb8f254911d3bf7ef8@sap.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 Hi Duncan,

Thanks a lot!
I disabled quotas and seconds later btrfs-cleaner returned to idle.
I will now run a couple of checks and then close this issue.

Regards
Simon