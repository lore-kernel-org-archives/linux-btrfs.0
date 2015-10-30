Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36071 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030642AbbJ3Jpr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 05:45:47 -0400
Received: by lbjm5 with SMTP id m5so46575033lbj.3
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 02:45:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 Oct 2015 10:45:45 +0100
Message-ID: <CADurGxxzrqGs9E0HE4hqfk9KAz1o_RNRdeiF3TEVhiSGnzhChA@mail.gmail.com>
Subject: RichACLs for BTRFS? (this time complete)
From: Marcel Ritter <ritter.marcel@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs-developers,

I just read about the possible/planned merge of richacl patches into
linux kernel 4.4.

s. http://lwn.net/Articles/661078/
s. http://lwn.net/Articles/661357/

Will btrfs support richacls with kernel 4.4?

According to the btrfs wiki, this topic has not been claimed:

https://btrfs.wiki.kernel.org/index.php/Project_ideas#RichACLs_.2F_NFS4_ACLS

As we'd like to use btrfs with NFSv4 I'd really like to see richacls on btrfs.

Hope someone can comment on this topic.

Bye,
   Marcel

PS: Please excuse my former incomplete posting.
