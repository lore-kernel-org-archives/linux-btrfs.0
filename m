From: Arnd Hannemann <arnd@arndnet.de>
Subject: Re: hard links
Date: Wed, 04 Apr 2012 21:39:39 +0200
Message-ID: <4F7CA37B.50006@arndnet.de>
References: <4F7C78FE.2020508@arndnet.de> <4F7CA218.5070902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-btrfs@vger.kernel.org
To: nspmangalore@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F7CA218.5070902@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Shyam,

Am 04.04.2012 21:33, schrieb Shyam Prasad N:
> On 04/04/2012 10:08 PM, Arnd Hannemann wrote:
>> Hi,
>>
>> today I experimented with hard links on btrfs and by this used all available inode space of a file.
>> Interestingly if this happens even a rename of such an filename to  an _equal length_ filename
>> fails:
>>
>> arnd@kallisto:/mnt/btrfs/tmp$ mv a b
>> mv: cannot move `a' to `b': Too many links
>>
>> Is this expected behavior?
>> There should be no reason to let this particular case fail?
>>

> What do you mean by 'used all available inode space'? What did you do exactly?


I created hard links of a file in the same directory until no additional one
can be created.

Eg.:
touch a
for i in {1..1000}; do ln a $i; done;


Best regards
Arnd
