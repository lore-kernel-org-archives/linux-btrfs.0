Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:46195 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755191AbdKBRce (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 13:32:34 -0400
Received: by mail-lf0-f54.google.com with SMTP id g70so339473lfl.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 10:32:33 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, ST <smntov@gmail.com>,
        Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs@vger.kernel.org
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
 <1509640139.1662.147.camel@gmail.com>
 <dd1852c3-93b7-ba0e-5853-c5336de4b9af@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <3bca6585-1f2c-3d9d-78b5-18bc773d05e0@gmail.com>
Date: Thu, 2 Nov 2017 20:32:31 +0300
MIME-Version: 1.0
In-Reply-To: <dd1852c3-93b7-ba0e-5853-c5336de4b9af@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

02.11.2017 20:13, Austin S. Hemmelgarn пишет:
>>
>> 2. I want to limit access to sftp, so there will be no custom commands
>> to execute...
> A custom version of the 'quota' command would be easy to add in there.
> In fact, this is really the only option right now, since setting up sudo
> (or doas, or whatever other privilege escalation tool) to allow users to
> check usage requires full access to the 'btrfs' command, which in turn
> opens you up to people escaping their quotas.

It should be possible to allow only "btrfs qgroup show", at least in sudo.

