From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH][btrfs progs] Update/clean up btrfs help and man page
Date: Sat, 9 Oct 2010 12:41:36 -0400
Message-ID: <AANLkTin_Onxqeu2cnj7zCk879hEBTxAe-4eh-i1DvsB9@mail.gmail.com>
References: <201009132124.09118.kreijack@libero.it> <4CB07234.1080102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CB07234.1080102@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 13.09.2010 21:23, Goffredo Baroncelli wrote:
> Hi all,
>
> enclose you can find a patch which improve the help of the btrfs
> commands and its man page. Regarding the help of the btrfs
> command: - moved the "subvolume set-default" command in the
> "subvolume" commands group - removed a wrong new line
>
> Regarding the btrfs command man page: - renaming the command
> "device balance" in "filesystem balance" (thanks to Andrea Phillipp
> to highlight that) - adding the entry "subvolume find-new"
>

Could you also document the defragment switches? At the moment, they
are only documented in the code, -c to compress, -f to force and -v
for verbose (even if verbose does not add any output other than the
version).
