From: Josef Bacik <josef@redhat.com>
Subject: Re: How to know whether disks "handle flush requests correctly"
Date: Fri, 06 May 2011 09:10:23 -0400
Message-ID: <4DC3F33F.80309@redhat.com>
References: <N1-HLiSwHA1HL@Safe-mail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Paul Schroeder <prq@Safe-mail.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <N1-HLiSwHA1HL@Safe-mail.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/06/2011 05:13 AM, Paul Schroeder wrote:
> The btrfs wiki Main Page warns that "it is currently possible to corrupt
> a filesystem irrecoverably if your machine crashes or loses power on disks
> that don't handle flush requests correctly."
>
> How do you know if this applies to your drives? Is there a way to test it,
> or a model list, or are newer SATA drives (magnetic, not SSDs) always ok?
> Does it depend on the controller? (I have a SiI 3114, latest BIOS.)
>
> I would also be using btrfs on top of dm-crypt (with the latest release
> kernel). Some kernel versions ago, the message that write barriers aren't
> supported disappeared; can I assume the device mapper / dm-crypt is not a
> problem with regards to flushing?
>

Yeah if you don't see those messages you can be fairly certain you are 
ok.  Thanks,

Josef
