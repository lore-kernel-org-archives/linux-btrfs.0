From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Subject: R: Patch to provide "btrfs subvolume last-gen".
Date: Wed, 3 Nov 2010 11:27:58 +0100 (CET)
Message-ID: <29406019.291621288780078238.JavaMail.defaultUser@defaultHost>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: <sean@support.tummy.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I suggest  to add a "-q" switch, in order to print only the transaction ID. So 
it easy to reuse the command in a script.
Something like:

   $ sudo ./btrfs subvolume last-gen /snap
   transid marker was 2808

   $ sudo ./btrfs subvolume last-gen -q /snaps
   2808


   $ sudo ./btrfs subvolume find-new /snaps \
         $(  sudo ./btrfs subvolume last-gen -q /snaps ) | \
         head -5

Please,  update the man page (man/btrfs.8.in) too.

Regards
G.Baroncelli

>----Messaggio originale----
>Da: sean@support.tummy.com
>Data: 03/11/2010 10.23
>A: <linux-btrfs@vger.kernel.org>
>Ogg: Patch to provide &quot;btrfs subvolume last-gen&quot;.
>
>Here is a patch to btrfs-progs to provide the command "subvolume last-gen":
>
>   $ sudo ./btrfs subvolume last-gen /.snaps/1h-20101102-010001
>   transid marker was 2808
>   $ sudo ./btrfs subvolume last-gen /.snaps/1h-20101102-020001/
>   transid marker was 2942
>   $
>
>So we can do something like:
>
>   $ sudo ./btrfs subvolume find-new /.snaps/1h-20101102-020001 2808 | head 
-5
>   inode 100399 file offset 2093056 len 4096 disk start 58160975872 offset 0
>gen 2901 flags NONE var/log/messages
>   inode 100399 file offset 2097152 len 4096 disk start 58161836032 offset 0
>gen 2934 flags NONE var/log/messages
>   inode 100400 file offset 40960 len 4096 disk start 58162188288 offset 0 
gen
>2941 flags NONE var/log/secure
>   inode 100401 file offset 139264 len 4096 disk start 58155618304 offset 0
>gen 2883 flags NONE var/log/maillog
>   inode 100401 file offset 143360 len 8192 disk start 58154278912 offset 0
>gen 2930 flags NONE var/log/maillog
>   $
>
>Otherwise, the only way I could figure out to do it was to pass a gen id
>that was hopefully too big to get the transid line:
>
>   $ sudo ./btrfs subvolume find-new /.snapshots/1h-20101102-010001 \
>         999999999999999
>   transid marker was 2808
>   $
>
>Unless I'm missing something...
>
>Sean
>


