Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61941 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3BCNdN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Feb 2013 08:33:13 -0500
Received: by mail-wi0-f173.google.com with SMTP id hq4so2041298wib.0
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Feb 2013 05:33:11 -0800 (PST)
Message-ID: <510E6714.7040206@statystyka.net>
Date: Sun, 03 Feb 2013 14:33:08 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Is it possible to use send & receive features to clone the btrfs
 partition efficiently (including all snapshots inside)?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is very difficult for me to find any good documentation on send & 
receive commands. Event the most recent btrfs progs man page (accessed 
from git today) says nothing.

I want to migrate data (including numerous read only snaphots) from 
linux-raid - based storage into a native raid btrfs.

I think that cloning via send & receive is a viable option.

Can anyone help me please? I've posted my question also on 
stackexchange: 
http://unix.stackexchange.com/questions/63528/how-to-clone-btrfs-filesystem-into-different-medium-preserving-snapshots-sharin 
. I will post the answer there, so everyone can benefit from it.

Thank you,

Adam Ryczkowski
+48505919892 <callto:+48505919892>
Skype:sisteczko <skype:sisteczko>

