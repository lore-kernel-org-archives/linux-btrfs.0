Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.111]:43258 "EHLO
        mail1.arhont.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964844AbeALRzy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 12:55:54 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail1.arhont.com (Postfix) with ESMTP id 96C6614009A2
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 17:49:44 +0000 (GMT)
Received: from mail1.arhont.com ([127.0.0.1])
        by localhost (mail1.arhont.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id eWYpvV1X2WBc for <linux-btrfs@vger.kernel.org>;
        Fri, 12 Jan 2018 17:49:39 +0000 (GMT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail1.arhont.com (Postfix) with ESMTP id 285BB14009A3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 17:49:39 +0000 (GMT)
Received: from mail1.arhont.com ([127.0.0.1])
        by localhost (mail1.arhont.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id fVshJYefMgzg for <linux-btrfs@vger.kernel.org>;
        Fri, 12 Jan 2018 17:49:39 +0000 (GMT)
Received: from mail1.arhont.com (localhost.localdomain [127.0.0.1])
        by mail1.arhont.com (Postfix) with ESMTP id E8D4A14009A2
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 17:49:38 +0000 (GMT)
Date: Fri, 12 Jan 2018 17:49:38 +0000 (GMT)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20055256.49.1515779377187.JavaMail.gkos@dynomob>
Subject: btrfs subvolume mount with different options
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

just wondering whether it is possible to mount two subvolumes with different mount options, i.e.

|
|- /a  defaults,compress-force=lza
|
|- /b  defaults,nodatacow


since, when both subvolumes are mounted, and when I change the option for one it is changed for all of them.


thanks in advance.

