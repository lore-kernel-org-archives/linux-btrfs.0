From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: Poor performance unlinking hard-linked files (repost)
Date: Sat, 20 Nov 2010 08:58:10 +1100
Message-ID: <20101119215810.GF12386@brong.net>
References: <1289618724.28645.1405062363@webmail.messagingengine.com>
 <20101116125445.GA3229@brong.net>
 <1289914577-sup-8535@think>
 <20101117041148.GA10048@brong.net>
 <1290094104-sup-8656@think>
 <20101118214631.GC2401@brong.net>
 <1290175586-sup-2461@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bron Gondwana <brong@fastmail.fm>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290175586-sup-2461@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 19, 2010 at 09:10:08AM -0500, Chris Mason wrote:
> Excerpts from Bron Gondwana's message of 2010-11-18 16:46:31 -0500:
> > On Thu, Nov 18, 2010 at 10:30:47AM -0500, Chris Mason wrote:
> > > > http://pastebin.com/Tg7agv42
> > > 
> > > Ok, we're mixing unlinks and fsyncs.  If it fsyncing directories too?
> > 
> > Nup.  I'm pretty sure it doesn't, just files.  Yes - there will certainly
> > be fsyncs going on as well - Cyrus is very careful to fsync everything it
> > cares about at the file level, but all it does with directories is mkdir
> > them if they don't exist.
> 
> Could you double check this one please?  fsyncing the directory is a ton
> more expensive, I just want to make sure it isn't part of the workload.
> 
> Otherwise it looks like we're seeking to read in the inode and unlink
> it.  One possibility is that we're not giving the elevator enough clues
> about the IO being synchronous.
> 
> Are you using cfq or deadline?  I bet we can improve the latencies using
> READ_SYNC.

I'm using deadline.

Here's a redacted strace of a single message upload:  (those gettimeofday
calls are actually caused by "trickle" being used to bandwidth limit these
things from nuking our internal network if they call go crazy at one)

All I'm seeing is the fsyncs on the files.  And some unnecessary mkdir
calls that I can probably remove, and an unneccary truncate on the
quota file.

Bron.

gettimeofday({1290202884, 848919}, NULL) = 0
gettimeofday({1290202884, 849006}, NULL) = 0
mkdir("/mnt", 0755)                     = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4", 0755)          = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/sync.", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/sync./11284", 0755) = -1 EEXIST (File exists)
open("/mnt/sata96b1d4/slots96b1p4/store23/data/sync./11284/9be294a24866fc162e5a2d48925d57642ff20a71", O_RDWR|O_CREAT|O_TRUNC, 0666) = 11
fstat64(11, {st_mode=S_IFREG|0600, st_size=0, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xf4cb2000
time(NULL)                              = 1290202884
read(0, "<CENSORED>"..., 4096) = 4096
fcntl64(0, F_GETFL)                     = 0x2 (flags O_RDWR)
gettimeofday({1290202884, 851014}, NULL) = 0
gettimeofday({1290202884, 851101}, NULL) = 0
write(11, "MIME-Version: 1.0\r\nContent-Transf"..., 4096) = 4096
time(NULL)                              = 1290202884
read(0, "<CENSORED>"..., 4096) = 4096
fcntl64(0, F_GETFL)                     = 0x2 (flags O_RDWR)
gettimeofday({1290202884, 851952}, NULL) = 0
gettimeofday({1290202884, 852038}, NULL) = 0
write(11, "<CENSORED>"..., 4096) = 4096
time(NULL)                              = 1290202884
read(0, "<CENSORED>"..., 4096) = 4096
fcntl64(0, F_GETFL)                     = 0x2 (flags O_RDWR)
gettimeofday({1290202884, 852644}, NULL) = 0
gettimeofday({1290202884, 852729}, NULL) = 0
write(11, "family: Arial; font-size: medium="..., 4096) = 4096
time(NULL)                              = 1290202884
read(0, "<CENSORED>"..., 4096) = 4096
fcntl64(0, F_GETFL)                     = 0x2 (flags O_RDWR)
gettimeofday({1290202884, 853303}, NULL) = 0
gettimeofday({1290202884, 853389}, NULL) = 0
write(11, "<CENSORED>"..., 4096) = 4096
time(NULL)                              = 1290202884
read(0, "<CENSORED>"..., 4096) = 4096
fcntl64(0, F_GETFL)                     = 0x2 (flags O_RDWR)
gettimeofday({1290202884, 853960}, NULL) = 0
gettimeofday({1290202884, 854045}, NULL) = 0
write(11, "<CENSORED>"..., 4096) = 4096
time(NULL)                              = 1290202884
read(0, "<CENSORED>"..., 4096) = 4096
fcntl64(0, F_GETFL)                     = 0x2 (flags O_RDWR)
gettimeofday({1290202884, 854617}, NULL) = 0
gettimeofday({1290202884, 854703}, NULL) = 0
write(11, "<CENSORED>"..., 4096) = 4096
time(NULL)                              = 1290202884
read(0, "<CENSORED>"..., 4096) = 910
fcntl64(0, F_GETFL)                     = 0x2 (flags O_RDWR)
gettimeofday({1290202884, 855431}, NULL) = 0
gettimeofday({1290202884, 855552}, NULL) = 0
write(11, "<CENSORED>"..., 4096) = 4096
write(11, "<CENSORED>"..., 668) = 668
fsync(11)                               = 0
close(11)                               = 0
munmap(0xf4cb2000, 4096)                = 0
write(1, "<CENSORED>"..., 32) = 32
time(NULL)                              = 1290202884
read(0, "<CENSORED>"..., 4096) = 731
fcntl64(0, F_GETFL)                     = 0x2 (flags O_RDWR)
gettimeofday({1290202884, 858721}, NULL) = 0
gettimeofday({1290202884, 858809}, NULL) = 0
open("/mnt/sata96b1m4/slots96b1p4/store23/conf/lock/domain/a/airpost.net/p/user/<CENSORED>/Drafts.lock", O_RDWR|O_CREAT|O_TRUNC, 0666) = 11
fcntl64(11, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=0, len=0}) = 0
fcntl64(6, F_SETLKW, {type=F_RDLCK, whence=SEEK_SET, start=0, len=0}) = 0
fstat64(6, {st_mode=S_IFREG|0600, st_size=809668, ...}) = 0
stat64("/mnt/sata96b1m4/slots96b1p4/store23/conf/mailboxes.db", {st_mode=S_IFREG|0600, st_size=809668, ...}) = 0
fcntl64(6, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=0, len=0}) = 0
open("/mnt/sata96b1m4/slots96b1p4/store23/meta/domain/a/airpost.net/p/user/<CENSORED>/Drafts/cyrus.index", O_RDWR) = 13
fstat64(13, {st_mode=S_IFREG|0600, st_size=9536, ...}) = 0
mmap2(NULL, 24576, PROT_READ, MAP_SHARED, 13, 0) = 0xf4cad000
fcntl64(13, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=0, len=0}) = 0
stat64("/mnt/sata96b1m4/slots96b1p4/store23/meta/domain/a/airpost.net/p/user/<CENSORED>/Drafts/cyrus.header", {st_mode=S_IFREG|0600, st_size=241, ...}) = 0
open("/mnt/sata96b1m4/slots96b1p4/store23/meta/domain/a/airpost.net/p/user/<CENSORED>/Drafts/cyrus.header", O_RDONLY) = 14
fstat64(14, {st_mode=S_IFREG|0600, st_size=241, ...}) = 0
mmap2(NULL, 241, PROT_READ, MAP_SHARED, 14, 0) = 0xf4cac000
munmap(0xf4cac000, 241)                 = 0
lseek(13, 9440, SEEK_SET)               = 9440
write(13, "<REWRITE INDEX RECORD (unrelated)>"..., 96) = 96
time(NULL)                              = 1290202884
stat64("/etc/localtime", {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
send(5, "<181>Nov 19 16:41:24 slots96b1p4/"..., 238, MSG_NOSIGNAL) = 238
mkdir("/mnt", 0755)                     = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4", 0755)          = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/sync.", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/sync./11284", 0755) = -1 EEXIST (File exists)
open("/mnt/sata96b1d4/slots96b1p4/store23/data/sync./11284/9be294a24866fc162e5a2d48925d57642ff20a71", O_RDONLY) = 15
fstat64(15, {st_mode=S_IFREG|0600, st_size=29340, ...}) = 0
mmap2(NULL, 29340, PROT_READ, MAP_SHARED, 15, 0) = 0xf4ca5000
munmap(0xf4ca5000, 29340)               = 0
stat64("/etc/localtime", {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
close(15)                               = 0
mkdir("/mnt", 0755)                     = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4", 0755)          = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/domain", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/domain/a", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/domain/a/airpost.net", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/domain/a/airpost.net/p", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/domain/a/airpost.net/p/user", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/domain/a/airpost.net/p/user/<CENSORED>", 0755) = -1 EEXIST (File exists)
mkdir("/mnt/sata96b1d4/slots96b1p4/store23/data/domain/a/airpost.net/p/user/<CENSORED>/Drafts", 0755) = -1 EEXIST (File exists)
link("/mnt/sata96b1d4/slots96b1p4/store23/data/sync./11284/9be294a24866fc162e5a2d48925d57642ff20a71", "/mnt/sata96b1d4/slots96b1p4/store23/data/domain/a/airpost.net/p/user/<CENSORED>/Drafts/4907.") = 0
utime("/mnt/sata96b1d4/slots96b1p4/store23/data/domain/a/airpost.net/p/user/<CENSORED>/Drafts/4907.", [2010/11/19-16:41:24, 2010/11/19-16:41:24]) = 0
open("/mnt/sata96b1m4/slots96b1p4/store23/meta/domain/a/airpost.net/p/user/<CENSORED>/Drafts/cyrus.cache", O_RDWR) = 15
fstat64(15, {st_mode=S_IFREG|0600, st_size=105488, ...}) = 0
mmap2(NULL, 114688, PROT_READ, MAP_SHARED, 15, 0) = 0xf4c91000
lseek(15, 0, SEEK_END)                  = 105488
write(15, "<CACHE ENTRY>"..., 1200) = 1200
lseek(13, 9536, SEEK_SET)               = 9536
write(13, "<INDEX RECORD FOR THIS UPLOAD>"..., 96) = 96
time(NULL)                              = 1290202884
stat64("/etc/localtime", {st_mode=S_IFREG|0644, st_size=3519, ...}) = 0
send(5, "<181>Nov 19 16:41:24 slots96b1p4/"..., 237, MSG_NOSIGNAL) = 237
time(NULL)                              = 1290202884
fsync(15)                               = 0
open("/mnt/sata96b1m4/slots96b1p4/store23/conf/domain/a/airpost.net/quota/p/user.<CENSORED>", O_RDWR) = 16
fcntl64(16, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=0, len=0}) = 0
fstat64(16, {st_mode=S_IFREG|0600, st_size=18, ...}) = 0
stat64("/mnt/sata96b1m4/slots96b1p4/store23/conf/domain/a/airpost.net/quota/p/user.<CENSORED>", {st_mode=S_IFREG|0600, st_size=18, ...}) = 0
fstat64(16, {st_mode=S_IFREG|0600, st_size=18, ...}) = 0
mmap2(NULL, 18, PROT_READ, MAP_SHARED, 16, 0) = 0xf4c90000
munmap(0xf4c90000, 18)                  = 0
unlink("/mnt/sata96b1m4/slots96b1p4/store23/conf/domain/a/airpost.net/quota/p/user.<CENSORED>.NEW") = -1 ENOENT (No such file or directory)
open("/mnt/sata96b1m4/slots96b1p4/store23/conf/domain/a/airpost.net/quota/p/user.<CENSORED>.NEW", O_RDWR|O_CREAT|O_TRUNC, 0666) = 17
fcntl64(17, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=0, len=0}) = 0
lseek(17, 0, SEEK_SET)                  = 0
write(17, "<CENSORED>"..., 18) = 18
ftruncate(17, 18)                       = 0
fsync(17)                               = 0
fstat64(17, {st_mode=S_IFREG|0600, st_size=18, ...}) = 0
rename("/mnt/sata96b1m4/slots96b1p4/store23/conf/domain/a/airpost.net/quota/p/user.<CENSORED>.NEW", "/mnt/sata96b1m4/slots96b1p4/store23/conf/domain/a/airpost.net/quota/p/user.<CENSORED>") = 0
fcntl64(17, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=0, len=0}) = 0
close(17)                               = 0
fcntl64(16, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=0, len=0}) = 0
close(16)                               = 0
lseek(13, 0, SEEK_SET)                  = 0
write(13, "<UPDATED INDEX HEADER>"..., 128) = 128
fsync(13)                               = 0
fcntl64(8, F_SETLKW, {type=F_WRLCK, whence=SEEK_SET, start=0, len=0}) = 0
fstat64(8, {st_mode=S_IFREG|0600, st_size=144, ...}) = 0
stat64("/mnt/sata96b1m4/slots96b1p4/store23/conf/statuscache.db", {st_mode=S_IFREG|0600, st_size=144, ...}) = 0
fcntl64(8, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=0, len=0}) = 0
fcntl64(13, F_SETLKW, {type=F_UNLCK, whence=SEEK_SET, start=0, len=0}) = 0
munmap(0xf4cad000, 24576)               = 0
munmap(0xf4c91000, 114688)              = 0
close(13)                               = 0



