Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44691 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbdFJSRI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Jun 2017 14:17:08 -0400
Subject: Re: btrfs native encryption
To: Hugo Mills <hugo@carfax.org.uk>,
        Filip Bystricky <filipbystricky@google.com>,
        linux-btrfs@vger.kernel.org
References: <CADvCoti_3iDwXfqepMdva6E6OOis_rqqVQ4adCV1T67PVhRrOQ@mail.gmail.com>
 <20170609160337.GA30723@carfax.org.uk>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <593C2ACE.2070705@oracle.com>
Date: Sun, 11 Jun 2017 02:22:22 +0900
MIME-Version: 1.0
In-Reply-To: <20170609160337.GA30723@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


   For phase-1 the idea was to make btrfs encryption inline with 
fs/crytpo which wasn't available when it started, so certainly there are 
things which could straight away filter out after its known what went 
into fs/crypto from ext4, especially the cryptography part.

  Now, 4.10 kernel based, btrfs encryption using fs/crypto is here [1]. 
It has under gone limited testing by me and yet to arrive at a 
conclusion on the file-name encryption, though its discussions are here 
[2], and patches aren't sent out to the BTRFS ML yet.


[1] Phase-1.
   Progs: https://github.com/asj/btrfs-progs-fscryptv1
   Kernel: https://github.com/asj/linux-btrfs-fscryptv1

[2] File name encryption discussions are here:
  (I don't see some of the emails I have in the google search, so 
instead I have listed the subject for your search).
    On the ext4 ML:
     Sub: fs/crypto: file-name encryption, optional ?
     Sub: fs/crypto: root read-access without key

Thanks, Anand
