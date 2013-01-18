Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:63249 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3ARRbq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 12:31:46 -0500
Received: by mail-bk0-f44.google.com with SMTP id w11so2139187bku.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2013 09:31:45 -0800 (PST)
Message-ID: <50F9871A.90307@gmail.com>
Date: Fri, 18 Jan 2013 18:32:10 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
References: <20130117174721.GD22785@twin.jikos.cz> <20130117175159.GA30656@shiny.int.fusionio.com>
In-Reply-To: <20130117175159.GA30656@shiny.int.fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
On 01/17/2013 06:51 PM, Chris Mason wrote:
> On Thu, Jan 17, 2013 at 10:47:21AM -0700, David Sterba wrote:
>> Hi Chris,
>>
[...]
>
> Thanks Dave, pulling these in.
what about my patches "Enhance the command btrfs filesystem df" (see my 
emails dated on 2012/11/02) [1] ?
You stated an interesting in these patches; however then I never heard 
anything...

Do you want  I resubmit ? I reached a general consensus ( == nobody was 
too unsatisfied :-) ) about the wording and the format.

And I have another question: it is possible to access to the RAID5/6 
develop branch. I am interesting to check how my patches work with 
RAID5/6...



>
> -chris

BR
G.Baroncelli


[1] http://permalink.gmane.org/gmane.comp.file-systems.btrfs/21071
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
