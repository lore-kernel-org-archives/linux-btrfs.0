Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39965 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab3EXUHd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 May 2013 16:07:33 -0400
Received: by mail-ie0-f174.google.com with SMTP id 10so13358585ied.19
        for <linux-btrfs@vger.kernel.org>; Fri, 24 May 2013 13:07:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
References: <CAAeznTr3rsJWcFWKoagNrduXGzP2AWaXMKY0FO8te2Xpa7XiHw@mail.gmail.com>
Date: Fri, 24 May 2013 14:07:33 -0600
Message-ID: <CAE5mzvj=rAmw9DgVL5HUx+Ue1stArhjV9UBM+6fsHUZMZK25Rg@mail.gmail.com>
Subject: Re: Recommended settings for SSD
From: cwillu <cwillu@cwillu.com>
To: Leonidas Spyropoulos <artafinde@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> At the moment I am using:
> defaults,noatime,nodiratime,ssd,subvol=@home

No need to specify ssd, it's automatically detected.
