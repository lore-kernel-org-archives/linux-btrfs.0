Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38362 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760735Ab2KAW2C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 18:28:02 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3074986obb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 15:28:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvjJmYGJvgjBGLv8kaUnZPDZu_QaU5s1=mYo55RmujeDNQ@mail.gmail.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
	<CAE5mzvjJmYGJvgjBGLv8kaUnZPDZu_QaU5s1=mYo55RmujeDNQ@mail.gmail.com>
Date: Fri, 2 Nov 2012 05:28:01 +0700
Message-ID: <CAG1y0sd-F6WrUFsvwAx+7LGD+V7a6XCoP9=XEkADPEAyEL1G1w@mail.gmail.com>
Subject: Re: [Request for review] [RFC] Add label support for snapshots and subvols
From: "Fajar A. Nugraha" <list@fajar.net>
To: cwillu <cwillu@cwillu.com>
Cc: Anand jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 2, 2012 at 5:16 AM, cwillu <cwillu@cwillu.com> wrote:
>>  btrfs fi label -t /btrfs/snap1-sv1
>> Prod-DB-sand-box-testing
>
> Why is this better than:
>
> # btrfs su snap /btrfs/Prod-DB /btrfs/Prod-DB-sand-box-testing
> # mv /btrfs/Prod-DB-sand-box-testing /btrfs/Prod-DB-production-test
> # ls /btrfs/
> Prod-DB  Prod-DB-production-test


... because it would mean possibilty to decouple subvol name from
whatever-data-you-need (in this case, a label).

My request, though, is to just implement properties, and USER
properties, like what we have in zfs. This seems to be a cleaner,
saner approach. For example, this is on Ubutu + zfsonlinux:

# zfs create rpool/u
# zfs set user:label="Some test filesystem" rpool/u
# zfs get creation,user:label rpool/u
NAME     PROPERTY    VALUE                  SOURCE
rpool/u  creation    Fri Nov  2  5:24 2012  -
rpool/u  user:label  Some test filesystem   local

More info about zfs user properties here:
http://docs.oracle.com/cd/E19082-01/817-2271/gdrcw/index.html

--
Fajar
