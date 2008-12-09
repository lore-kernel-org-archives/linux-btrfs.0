From: "Miguel Figueiredo Mascarenhas Sousa Filipe"
	<miguel.filipe@gmail.com>
Subject: Re: Selective Compression/Encryption
Date: Tue, 9 Dec 2008 15:45:10 +0000
Message-ID: <f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com>
References: <20081209145952.GA30494@tux64-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Lee Trager" <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081209145952.GA30494@tux64-03>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

On Tue, Dec 9, 2008 at 2:59 PM, Lee Trager <lt73@cs.drexel.edu> wrote:
> Currently compression and I assume if encryption is implemented it is
> turned on or off during mount. There are however many times when a user may
> want to select which files/directories they want to compress or encrypt.
> This will also be helpful when implementing btrfs support in grub for
> example. We can say the disk can be compressed/encrypted except for /boot so
> compression/encryption doesn't have to be implemented in grub.
>
> I was thinking of adding this functionality to the userspace application
> btrfstune. The way I was thinking of doing this is when btrfstune +c is
> applied to a directory or file the directory(and all its contents) or
> file will always be compressed reguardless of how the filesystem is
> mounted. The opposite would happen when btrfstune -c is used.
>
> Would this be a reasonable thing to implement? Any suggestions before I
> start doing this?
>

Things like compression or encription should be used at the "volume" level.
So.. if a user wants a specific set of files or dirs ..they should
create a mount-point/volume like:

private_vol
bigarchives_vol

and set those volumes as compressed or encripted volumes

Regarding usability, the best would be for the sub-volume creation
tool to optionally allow passing encription/compression arguments.


and then:
 should mount those volumes somewhere like: ~/Confidential or ~/Archives.

Basically, do it at the directory level (which in btrfs is at the
sub-volume level).
File-level granularity is totally unmanageable in the long term.

Kind regards,


-- 
Miguel Sousa Filipe
