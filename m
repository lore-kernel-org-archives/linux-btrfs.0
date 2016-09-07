Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:33839 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752990AbcIGRdk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 13:33:40 -0400
Received: by mail-it0-f45.google.com with SMTP id i184so31877054itf.1
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Sep 2016 10:33:39 -0700 (PDT)
Subject: Re: Security implications of btrfs receive?
To: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <4a00b682-c674-a46f-798e-d98b3e517f02@gmail.com>
 <f954e01c-3ccf-5b44-3fde-e627537f2af2@gmail.com>
 <f03940e1-cf4c-7354-97f4-8801ca4b4304@cobb.uk.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6b29e923-4cef-cd78-cd98-d59419cc2341@gmail.com>
Date: Wed, 7 Sep 2016 13:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <f03940e1-cf4c-7354-97f4-8801ca4b4304@cobb.uk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-07 12:10, Graham Cobb wrote:
> On 07/09/16 16:20, Austin S. Hemmelgarn wrote:
>> I should probably add to this that you shouldn't be accepting
>> send/receive data streams from untrusted sources anyway.  While it
>> probably won't crash your system, it's not intended for use as something
>> like a network service.  If you're sending a subvolume over an untrusted
>> network, you should be tunneling it through SSH or something similar,
>> and then using that to provide source verification and data integrity
>> guarantees, and if you can't trust the system's your running backups
>> for, then you have bigger issues to deal with.
>
> In my personal case I'm not talking about accepting streams from
> untrusted sources (although that is also a perfectly reasonable question
> to discuss).  My concern is if one of my (well managed and trusted but
> never perfect) systems is hacked, can the intruder use that as an entry
> to attack others of my systems?
Probably not directly.  They could get data from the other systems 
backups, but unless something's seriously broken, there should be no way 
for them to inject data into those backups.  IOW, it should be about the 
same level of security you would get from doing this with tar based 
backups with an individual user for each system and world readable files.
>
> In particular, I never trust my systems which live on the internet with
> automated access to my personal systems (without a human providing
> additional passwords/keys) although I do allow some automated accesses
> the other way around.  I am trying to determine if sharing
> btrfs-send-based backups would open a vulnerability.
As far as I can tell, the only vulnerability would be through 
information leaks.  In essence, this should in theory only be usable as 
a side-channel to obtain information to then use for a real attack 
(assuming of course that you have proper at-rest encryption for any 
sensitive data on your system).
>
> There are articles on the web suggesting that centralised
> btrfs-send-based backups are a good idea (using ssh access with separate
> keys for each system which automatically invoke btrfs-receive into a
> system-specific path).  My tests so far suggest that this may not be as
> secure as the articles imply.
While just doing that in general is not all that secure, if you make 
sure each system-specific path is on it's own filesystem (this can be 
done with thin provisioning if you are short on space), then that should 
eliminate most of the security issues.  If you're feeling really 
adventurous and don't entirely trust the stability of the code involved, 
you could instead force it to run a script which invokes btrfs-receive 
in a per-instance dedicated sandbox constrained to that filesystem.

