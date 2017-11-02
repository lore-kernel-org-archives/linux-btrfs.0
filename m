Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:53814 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751587AbdKBRNR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 13:13:17 -0400
Received: by mail-io0-f175.google.com with SMTP id 189so508119iow.10
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 10:13:17 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: ST <smntov@gmail.com>, Marat Khalili <mkh@rqc.ru>
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
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dd1852c3-93b7-ba0e-5853-c5336de4b9af@gmail.com>
Date: Thu, 2 Nov 2017 13:13:13 -0400
MIME-Version: 1.0
In-Reply-To: <1509640139.1662.147.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-02 12:28, ST wrote:
> On Thu, 2017-11-02 at 19:16 +0300, Marat Khalili wrote:
>>> Could somebody among developers please elaborate on this issue - is
>> checking quota going always to be done by root? If so - btrfs might be
>> a no-go for our use case...
>>
>> Not a developer, but sysadmin here: what prevents you from either
>> creating suid executable for this or configuring sudoers to let users
>> call specific commands they need?
> 
> 1. If designers have decided to limit access to that info only to root -
> they must have their reasons to do so, and letting everybody do that is
> probably contrary to those reasons.
I wouldn't say this is a compelling argument.  Some things that probably 
should be root only aren't, and others that should not be are, so the 
whole thing is rather haphazard.  Unless one of the developers can 
comment either way, I wouldn't worry too much about this.
> 
> 2. I want to limit access to sftp, so there will be no custom commands
> to execute...
A custom version of the 'quota' command would be easy to add in there. 
In fact, this is really the only option right now, since setting up sudo 
(or doas, or whatever other privilege escalation tool) to allow users to 
check usage requires full access to the 'btrfs' command, which in turn 
opens you up to people escaping their quotas.
> 
> 3. sftp clients (especially those for windows) can determine quota - and
> they do it probably in some standard way - which doesn't seem to be
> compatible with btrfs...
They call the 'quota' command.  This isn't integrated with BTRFS qgroups 
though because the VFS quota API (which it uses) has significantly 
different semantics than BTRFS quota groups.  VFS quotas are per-user 
(or on rare occasion, per 'project'), whereas BTRFS quota groups apply 
to subvolumes, not users, which is in turn part of why it's possible to 
escape quota requirements on BTRFS.
