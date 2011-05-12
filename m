From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: "btrfs filesystem label" command
Date: Thu, 12 May 2011 22:05:55 +0200
Message-ID: <4DCC3DA3.7030008@inwind.it>
References: <4422201.237.1305141322836.JavaMail.root@mail.placs.net>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: BJ Quinn <bj@placs.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4422201.237.1305141322836.JavaMail.root@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/11/2011 09:15 PM, BJ Quinn wrote:
> Thanks!
> 
> I had to install libuuid-devel (Fedora) to get past an error not
> being able to find uuid.h when running make. It works perfectly.
> 
> This seems like such a basic functionality, have they accepted your
> patches? Do you know if this is going to get merged?


Yes, this patch was merged and is in the "tmp" branch of the main
btrfs-prog git repository [*]. Unfortunately this brach doesn't even
compile (or almost it gives me an error). I don't know when it will be
available.

Regards
G.Baroncelli

[*]
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=commit;h=d1dc6a9cff7e2fe4f335ca783a4b033457b3e184



> 
> -BJ
> 
> 
> From: "Goffredo Baroncelli" <kreijack@inwind.it> To: "BJ Quinn"
> <bj@placs.net> Cc: linux-btrfs@vger.kernel.org Sent: Tuesday, May 10,
> 2011 1:18:04 PM Subject: Re: "btrfs filesystem label" command
> 
> Hi,
> 
> I suppose that you are familiar with 'git' and the standard unix
> command (like cd, make...). The quick way is the following:
> 
> $ cd /tmp $ git clone -b label \ 
> http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git $ cd
> btrfs-progs-unstable.git $ make $ ./btrfs
> 
> 
> Hoping that this may help you
> 
> Regards G.Baroncelli
> 
> On 05/09/2011 11:36 PM, BJ Quinn wrote:
>> Hi,
>> 
>> Sorry to ask what's probably a painfully obvious question, but I'd
>> like to use your btrfs filesystem label command. For the life of
>> me, I can't quite figure out what the process would be to download
>> the btrfs-progs sources and apply your patch and use the command.
>> Can you point me in the right direction?
>> 
>> Thanks!
>> 
>> -BJ Quinn
>> 
> 
> 

