Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:56135 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab3EXUGr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 16:06:47 -0400
Received: by mail-la0-f43.google.com with SMTP id ez20so4893405lab.30
        for <linux-btrfs@vger.kernel.org>; Fri, 24 May 2013 13:06:45 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 May 2013 21:06:45 +0100
Message-ID: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
Subject: Recommended settings for SSD
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I just got myself a new SSD and decided to install yet another time
btrfs with ubuntu 13.04. I would like to ask if you suggest anything
for recommended options for mount on Crucial S4 SSD.

At the moment I am using:
defaults,noatime,nodiratime,ssd,subvol=@home

Anything else someone recommends for performance, stability?

Thanks in advance
Leonidas

--
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
