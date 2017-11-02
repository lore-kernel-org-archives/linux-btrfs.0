Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:48112 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbdKBQ3C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 12:29:02 -0400
Received: by mail-wm0-f65.google.com with SMTP id r196so136038wmf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 09:29:02 -0700 (PDT)
Message-ID: <1509640139.1662.147.camel@gmail.com>
Subject: Re: Several questions regarding btrfs
From: ST <smntov@gmail.com>
To: Marat Khalili <mkh@rqc.ru>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Date: Thu, 02 Nov 2017 18:28:59 +0200
In-Reply-To: <E7316F3D-708C-4D5E-AB4B-F54B0B8471C1@rqc.ru>
References: <1509467017.1662.37.camel@gmail.com>
         <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
         <1509480384.1662.84.camel@gmail.com>
         <ea097624-d485-9423-387f-3c9427508883@gmail.com>
         <1509545153.1662.105.camel@gmail.com>
         <7e8d6430-01e0-ba8e-5822-510ba1daef9f@gmail.com>
         <1509613781.1662.115.camel@gmail.com>
         <173c1ba3-1a05-1a27-7bee-22141200cbf8@gmail.com>
         <1509638366.1662.142.camel@gmail.com>
         <E7316F3D-708C-4D5E-AB4B-F54B0B8471C1@rqc.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2017-11-02 at 19:16 +0300, Marat Khalili wrote:
> > Could somebody among developers please elaborate on this issue - is
> checking quota going always to be done by root? If so - btrfs might be
> a no-go for our use case...
> 
> Not a developer, but sysadmin here: what prevents you from either
> creating suid executable for this or configuring sudoers to let users
> call specific commands they need?

1. If designers have decided to limit access to that info only to root -
they must have their reasons to do so, and letting everybody do that is
probably contrary to those reasons.

2. I want to limit access to sftp, so there will be no custom commands
to execute...

3. sftp clients (especially those for windows) can determine quota - and
they do it probably in some standard way - which doesn't seem to be
compatible with btrfs...

