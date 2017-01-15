Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33925 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdAOOqq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 09:46:46 -0500
From: Anand Jain <anand.jain@oracle.com>
Subject: [LSF/MM TOPIC] [LSF/MM ATTEND] BTRFS Encryption
To: lsf-pc@lists.linux-foundation.org
Cc: anand.jain@oracle.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <32cc6d29-8ec8-f43e-20ae-585a7ea92771@oracle.com>
Date: Sun, 15 Jan 2017 22:50:46 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  I am working on BTRFS Encryption stage 2 design [1], which circles
  around the data center solution requisites. I shall be presenting
  an overview of the proposed design, so to obtain the constructive
  feedback and comments. And, I hope this will help to finalize on the
  design before it is taken up for the implementation.

  Though the current experiment is only with in BTRFS, the
  encryption-method part of the design should be part of fs/crypto,
  when it is appropriate.

  The presentation and the review will be in two parts, the
  encryption-method part, in which the experts from the fs/crypto may
  like to participate. And the btrfs part in which the btrfs experts
  may like to provide their comments on the proposed design in
  specific to the btrfs.


  [1] (Working draft, I hope to put more details into it before the LSF).
 
https://docs.google.com/document/d/1jWB3lyY2PF5CSAzcOnR8Yzh_45xU3Ub9bf3zKoMruWs/edit?usp=sharing



Thanks, Anand


