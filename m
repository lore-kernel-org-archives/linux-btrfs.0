Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:54598 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752003AbdLJPtM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 10:49:12 -0500
Date: Sun, 10 Dec 2017 16:49:10 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171210154910.GA13443@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
 <20171202093301.GA28256@polanet.pl>
 <65f1545c-7fc5-ee26-ed6b-cf1ed6e4f226@gmx.com>
 <20171210112738.GA24090@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20171210112738.GA24090@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 10, 2017 at 12:27:38 +0100, Tomasz Pala wrote:

> I have found a directory - pam_abl databases, which occupy 10 MB (yes,
> TEN MEGAbytes) and released ...8.7 GB (almost NINE GIGAbytes) after

#  df            
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        64G   61G  2.8G  96% /

#  btrfs fi du .
     Total   Exclusive  Set shared  Filename
     0.00B       0.00B           -  ./1/__db.register
  10.00MiB    10.00MiB           -  ./1/log.0000000001
  16.00KiB       0.00B           -  ./1/hosts.db
  16.00KiB       0.00B           -  ./1/users.db
 168.00KiB       0.00B           -  ./1/__db.001
  40.00KiB       0.00B           -  ./1/__db.002
  44.00KiB       0.00B           -  ./1/__db.003
  10.28MiB    10.00MiB           -  ./1
     0.00B       0.00B           -  ./__db.register
  16.00KiB    16.00KiB           -  ./hosts.db
  16.00KiB    16.00KiB           -  ./users.db
  10.00MiB    10.00MiB           -  ./log.0000000013
     0.00B       0.00B           -  ./__db.001
     0.00B       0.00B           -  ./__db.002
     0.00B       0.00B           -  ./__db.003
  20.31MiB    20.03MiB   284.00KiB  .

#  btrfs fi defragment log.0000000013 
#  df
/dev/sda2        64G   54G  9.4G  86% /


6.6 GB / 10 MB = 660:1 overhead within 1 day of uptime.

-- 
Tomasz Pala <gotar@pld-linux.org>
