From: Josef Bacik <josef@redhat.com>
Subject: Re: snapshot-removal - timeline ?
Date: Wed, 5 Aug 2009 07:54:20 -0400
Message-ID: <20090805115420.GB3655@dhcp231-156.rdu.redhat.com>
References: <1552F85577A149D68B0BFF2A44E0FF0A@bui.materna.com> <20090803130412.GB3570@think> <10F3F7E4-276B-49C3-B944-61320D634C93@karlsbakk.net> <20090803161800.GB5492@think> <7EC11C2E-889E-42A4-80D8-EA7E80F4963D@karlsbakk.net> <20090804183307.GG5693@think> <5D3C1A84-7A56-48CC-9C78-EDC582ED6B54@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: roy@karlsbakk.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <5D3C1A84-7A56-48CC-9C78-EDC582ED6B54@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2009 at 01:18:33PM +0200, Roy Sigurd Karlsbakk wrote:
> On 4. aug.. 2009, at 20.33, Chris Mason wrote:
>
>>> It's strange that such a small thing should be delayed so much. If
>>> snapshot removal was working, I'm quite sure we might get more users
>>> and thereby more stable code faster.
>>
>> It's a small feature but it gets deep into the difficult parts of the
>> dentry cache to do it right.  So, it definitely isn't easy.
>
>
> I'd say it's a pretty elemetary feature to be able to remove something  
> you have created. I know, you can remove the files and so on, but still, 
> having a bunch of old and empty snapshots lying around is no good.
>

Patches are always welcome.

Josef
