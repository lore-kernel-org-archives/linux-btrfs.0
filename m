From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: btrfs panic - BUG: soft lockup - CPU#0 stuck for 61s! [fs_mark:4573]
Date: Wed, 04 Jun 2008 15:46:10 -0400
Message-ID: <4846F102.3000801@gmail.com>
References: <4844336F.1010807@redhat.com> <20080604012701.GC7805@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080604012701.GC7805@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Jun 02, 2008 at 01:52:47PM -0400, Ric Wheeler wrote:
>   
>> I can reliably get btrfs to panic by running my fs_mark code on a newly  
>> created file system with lots of threads on an 8-way box. If this is too  
>> aggressive, let me know ;-)
>>
>> Here is a summary of the panic:
>>     
>
> I think this is due to a corruption on the data=ordered list.  I'm
> testing a patch out here.
>
> -chris
>   
I can test it tomorrow if you send it on... Thanks!

ric

