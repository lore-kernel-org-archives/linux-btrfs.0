From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD Optimizations
Date: Wed, 10 Mar 2010 23:13:02 +0000
Message-ID: <4B98277E.2080103@bobich.net>
References: <4B97F7CE.4030405@bobich.net> <ef88cc6b1003101314g4a8cdbccuaf0a965d908ee187@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ef88cc6b1003101314g4a8cdbccuaf0a965d908ee187@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Marcus Fritzsch wrote:
> Hi there,
> 
> On Wed, Mar 10, 2010 at 8:49 PM, Gordan Bobic <gordan@bobich.net> wrote:
>> [...]
>> Are there similar optimizations available in BTRFS?
> 
> There is an SSD mount option available[1].
> 
> [1] http://btrfs.wiki.kernel.org/index.php/Getting_started#Mount_Options

But what _exactly_ does it do?

Is there a way to leverage any knowledge of erase block size at file 
system creation time?

Are there any special parameters that might affect locations of 
superblocks and metadata?

Is there a way to ensure they don't span erase block boundaries?

What about ATA TRIM command support? Is this available? Is it included 
in the version in Fedora 13?

Gordan
