From: Sebastian Schikschneit <sebastian@schikschneit.eu>
Subject: phenomenon of 0 Byte files while overwriting
Date: Wed, 11 Jan 2012 10:23:39 +0100
Message-ID: <CA+YvvZyA0EOc8wgPNg0=PfdVMX=wDV_B=1zVzL8-1FRj5J2KZA@mail.gmail.com>
References: <CA+YvvZzLZ_CmwvJK=NNuimsxaDTZpS0asQhoAZOY0PAm=kzpoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+YvvZzLZ_CmwvJK=NNuimsxaDTZpS0asQhoAZOY0PAm=kzpoQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dear BTRFS-Developer,

first of all sorry for my broken english - i hope you understand what
i want to tell!?
Since a few days i have a phenomenon when i try to overwrite a file.
Description of the system:

- linux server (3.0.0.15 - Ubuntu)
- btrfs 0.19
- samba 3.5.11
- windows 7 x64 client
- user: userX:users
- file permissions 764 - userX - users
- filesystem btrfs als single (approx 2TB) an btrfs as raid1 (approx 372GB)

I tried to overwrite an existing file on the server via samba. An
error was reported (windows error messages... 0x8007003a - the server
could not do that...). After cancel this operation the file at the
server was 0 Byte and clould not overwritten and now i could not
delete the file via samba (per ssh and console it is possible). If i
delete first and the copy the file to the server everything works
fine. If i move the file on the server to anywhere and back,
everything works fine.
An btrfs-defrag does not help! After an btrfs-balance-run everything
seems to work!
I dont have this phenomenon while using ext3 with this samba configuration.
Do you have any ideas?
I'm locking forward to hearing from you.

Best wishes and thanks.

Sebastian Schikschneit
