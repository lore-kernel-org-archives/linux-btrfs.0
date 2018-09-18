Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn3nam01on0087.outbound.protection.outlook.com ([104.47.33.87]:9472
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729695AbeISACa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:02:30 -0400
From: "Gervais, Francois" <FGervais@distech-controls.com>
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs receive incremental stream on another uuid
Date: Tue, 18 Sep 2018 18:28:37 +0000
Message-ID: <BN6PR01MB253106EF09795A3F64C61AC8F31D0@BN6PR01MB2531.prod.exchangelabs.com>
References: <BN6PR01MB2531F06B0557C31005C5E6E7F31D0@BN6PR01MB2531.prod.exchangelabs.com>,<eeba538c-bcc1-8f70-c9b7-b277eec57b36@gmail.com>
In-Reply-To: <eeba538c-bcc1-8f70-c9b7-b277eec57b36@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> No. It is already possible (by setting received UUID); it should not be
made too open to easy abuse.


Do you mean edit the UUID in the byte stream before btrfs receive?
