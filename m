Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f49.google.com ([209.85.167.49]:34212 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729946AbeISAOf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:14:35 -0400
Received: by mail-lf1-f49.google.com with SMTP id c29-v6so2818961lfj.1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2018 11:40:40 -0700 (PDT)
Subject: Re: btrfs receive incremental stream on another uuid
To: "Gervais, Francois" <FGervais@distech-controls.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <BN6PR01MB2531F06B0557C31005C5E6E7F31D0@BN6PR01MB2531.prod.exchangelabs.com>
 <eeba538c-bcc1-8f70-c9b7-b277eec57b36@gmail.com>
 <BN6PR01MB253106EF09795A3F64C61AC8F31D0@BN6PR01MB2531.prod.exchangelabs.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <3d1cfe1f-483d-0772-d605-acba2734fa59@gmail.com>
Date: Tue, 18 Sep 2018 21:40:38 +0300
MIME-Version: 1.0
In-Reply-To: <BN6PR01MB253106EF09795A3F64C61AC8F31D0@BN6PR01MB2531.prod.exchangelabs.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.09.2018 21:28, Gervais, Francois пишет:
>> No. It is already possible (by setting received UUID); it should not be
> made too open to easy abuse.
> 
> 
> Do you mean edit the UUID in the byte stream before btrfs receive?
> 
No, I mean setting received UUID on subvolume. Unfortunately, it is
possible. Fortunately, it is not trivially done.
