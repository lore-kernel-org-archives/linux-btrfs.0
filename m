Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.ensi-bourges.fr ([195.221.38.25]:49130 "EHLO
	ensi-bourges.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933006Ab2JXQ7n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 12:59:43 -0400
Received: from unknown (HELO webmail.ensi-bourges.fr) (Authenticated_user:frantz.hacquard@[195.221.38.6])
          (envelope-sender <frantz.hacquard@ensi-bourges.fr>)
          by mail.ensi-bourges.fr (qmail-ldap-1.03) with SMTP
          for <linux-btrfs@vger.kernel.org>; 24 Oct 2012 16:52:05 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 24 Oct 2012 18:53:01 +0200
From: "frantz.hacquard" <frantz.hacquard@ensi-bourges.fr>
To: <linux-btrfs@vger.kernel.org>
Subject: help with btrfs send
Message-ID: <d867c8a573d19560c7b7f3aba7394b10@ensi-bourges.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 Hi,

 I don't know if it's the good place to ask my question.
 I'm a french student who studies IT.
 I'm working on a project with the btrfs filesystem on Gentoo 64 bits.
 I have to create snapshots and to compare the differences between them 
 (new files, deleted files, modified files...).
 So i tried to use btrfs send -i old-snap new-snap.
 To make this command working i created my snapshots thanks to the -r 
 option.
 However i only see on the standard output many weird characters but i 
 don't understand them.
 I know it's still in developement but is it working ?
 I tried with kernel 3.6.2 and 3.7.0

 Thanks for help.
