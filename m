Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm.newmedia-net.de ([217.113.179.122]:54190 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbdASKpD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jan 2017 05:45:03 -0500
To: linux-btrfs@vger.kernel.org
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <7473ea27-9716-33fb-ecec-2ec52fac3820@dd-wrt.com>
Date: Thu, 19 Jan 2017 11:06:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: btrfs recovery
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I have a question. after a power outage my system was turning into a 
unrecoverable state using btrfs (kernel 4.9)
since im running --init-extent-tree now for 3 days i'm asking how long 
this process normally takes and why it outputs millions of lines like

Backref 1562890240 root 262 owner 483059214 offset 0 num_refs 0 not 
found in extent tree
Incorrect local backref count on 1562890240 root 262 owner 483059214 
offset 0 found 1 wanted 0 back 0x23b0211d0
backpointer mismatch on [1562890240 4096]
adding new data backref on 1562890240 root 262 owner 483059214 offset 0 
found 1
Repaired extent references for 1562890240

please avoid typical answers like "potential dangerous operation" since 
all repair options are declared as potenial dangerous.


Sebastian

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565

